using Letu.Basis.Admin.OrganizationUnits.Dtos;
using Letu.Repository;
using Volo.Abp.Domain.Entities;
using Volo.Abp;
using Letu.Logging.BusinessLogs;

namespace Letu.Basis.Admin.OrganizationUnits;

public class OrganizationUnitAppService : BasisAppService, IOrganizationUnitAppService
{
    private readonly IFreeSqlRepository<OrganizationUnit> ouRepository;
    private const int SegmentWidth = 4; // 每级编码宽度，例如 0001、0002

    public OrganizationUnitAppService(IFreeSqlRepository<OrganizationUnit> ouRepository)
    {
        this.ouRepository = ouRepository;
    }

    [BusinessLog("组织机构管理", BusinessOperateType.Create, "创建组织机构{{Name}}")]

    public async Task<bool> AddOrganizationUnitAsync(OrganizationUnitCreateOrUpdateInput input)
    {
        // 同级、忽略大小写的重名校验（仅应用层）
        if (await ExistsDuplicateNameAsync(input.ParentId, input.Name))
        {
            throw new UserFriendlyException("同级下已存在相同名称的机构");
        }
        var entity = ObjectMapper.Map<OrganizationUnitCreateOrUpdateInput, OrganizationUnit>(input);
        // 生成层级编码 Code（物化路径）
        entity.Code = await GenerateNextCodeAsync(input.ParentId);
        entity = await ouRepository.InsertAsync(entity);

        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddEntityId(entity.Id);

        return true;
    }

    
    [BusinessLog("组织机构管理", BusinessOperateType.Delete, "删除组织机构{{Name}}")]

    public async Task<bool> DeleteOrganizationUnitAsync(Guid id)
    {
        // 连同子级一并删除
        var entity = await ouRepository.Where(x => x.Id == id).FirstAsync();
        if (entity == null)
        {
            return true;
        }
        var codePrefix = entity.Code;
        await ouRepository.DeleteAsync(x => x.Code.StartsWith(codePrefix));
        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddEntityId(id);

        return true;
    }

    public async Task<List<OrganizationUnitListOutput>> GetOrganizationUnitListAsync(OrganizationUnitListInput input)
    {
        var filter = await ouRepository
            .WhereIf(!string.IsNullOrEmpty(input.Name), x => x.Name.Contains(input.Name!))
            .WhereIf(!string.IsNullOrEmpty(input.Category), x => x.Category == input.Category)
            .WhereIf(!string.IsNullOrEmpty(input.Type), x => x.Type == input.Type)
            .OrderBy(x => x.Sort).ToListAsync();
        var result = ObjectMapper.Map<List<OrganizationUnit>, List<OrganizationUnitListOutput>>(filter);

        return result;
    }

    [BusinessLog("组织机构管理", BusinessOperateType.Update, "更新组织机构{{Name}}")]

    public async Task<bool> UpdateOrganizationUnitAsync(Guid id, OrganizationUnitCreateOrUpdateInput input)
    {
        var entity = await ouRepository.Where(x => x.Id == id).FirstAsync();
        if (entity == null)
        {
            throw new EntityNotFoundException(typeof(OrganizationUnit), id);
        }

        // 名称与排序直接更新
        var newName = input.Name ?? entity.Name;
        // 同级、忽略大小写的重名校验（仅应用层）
        if (await ExistsDuplicateNameAsync(input.ParentId, newName, id))
        {
            throw new UserFriendlyException("同级下已存在相同名称的机构");
        }
        entity.Name = newName;
        entity.Sort = input.Sort;
        
        // 更新其他字段
        entity.Category = input.Category;
        entity.Type = input.Type;
        entity.RegionCode = input.RegionCode;
        entity.StreetName = input.StreetName;
        entity.Address = input.Address;
        entity.ContactPerson = input.ContactPerson;
        entity.ContactPhone = input.ContactPhone;
        entity.Longitude = input.Longitude;
        entity.Latitude = input.Latitude;

        // 父级是否发生变化
        var parentChanged = entity.ParentId != input.ParentId;
        if (parentChanged)
        {
            await RecalculateSubtreeCodesAsync(entity, input.ParentId);
        }

        await ouRepository.UpdateAsync(entity);
        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddEntityId(id);

        return true;
    }

    /// <summary>
    /// 检查同级下是否存在重名（忽略大小写），可排除指定 Id
    /// </summary>
    private async Task<bool> ExistsDuplicateNameAsync(Guid? parentId, string? name, Guid? excludeId = null)
    {
        var lowered = (name ?? string.Empty).ToLower();
        var query = ouRepository.Where(x => x.ParentId == parentId && x.Name.ToLower() == lowered);
        if (excludeId.HasValue)
        {
            query = query.Where(x => x.Id != excludeId.Value);
        }
        return await query.AnyAsync();
    }

    /// <summary>
    /// 生成下一个子节点的完整编码（父编码 + 新段）
    /// </summary>
    private async Task<string> GenerateNextCodeAsync(Guid? parentId)
    {
        string prefix = string.Empty;
        if (parentId.HasValue)
        {
            var parent = await ouRepository.Where(x => x.Id == parentId.Value).FirstAsync();
            if (parent == null)
            {
                throw new EntityNotFoundException(typeof(OrganizationUnit), parentId!.Value);
            }
            prefix = parent.Code;
        }

        // 获取同级最大编码，取最后一段 + 1
        var siblingMax = await ouRepository.Where(x => x.ParentId == parentId)
            .OrderByDescending(x => x.Code)
            .FirstAsync();

        int nextNumber = 1;
        if (siblingMax != null)
        {
            var lastSeg = siblingMax.Code.Substring(prefix.Length, SegmentWidth);
            if (int.TryParse(lastSeg, out var n))
            {
                nextNumber = n + 1;
            }
        }
        var nextSeg = nextNumber.ToString().PadLeft(SegmentWidth, '0');
        return prefix + nextSeg;
    }

    /// <summary>
    /// 变更父级时，重算本节点及所有子孙节点的编码
    /// </summary>
    private async Task RecalculateSubtreeCodesAsync(OrganizationUnit root, Guid? newParentId)
    {
        var oldCode = root.Code;
        var newRootCode = await GenerateNextCodeAsync(newParentId);

        // 查询整棵子树
        var subtree = await ouRepository.Where(x => x.Code.StartsWith(oldCode)).ToListAsync();
        foreach (var item in subtree)
        {
            var suffix = item.Code.Substring(oldCode.Length);
            item.Code = newRootCode + suffix;
            if (item.Id == root.Id)
            {
                item.ParentId = newParentId;
            }
        }

        // 批量更新子树
        foreach (var item in subtree)
        {
            await ouRepository.UpdateAsync(item);
        }

        // 更新传入 root 引用的字段，保持一致
        root.Code = newRootCode;
        root.ParentId = newParentId;
    }

}
