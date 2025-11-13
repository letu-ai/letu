using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.UserTags.Dtos;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Logging.BusinessLogs;
using Letu.Repository;

namespace Letu.Basis.Admin.UserTags;

public class UserTagAppService : BasisAppService, IUserTagAppService
{
    private readonly IFreeSqlRepository<UserTag> tagRepository;
    private readonly IFreeSqlRepository<UserInTag> userTagRepository;

    public UserTagAppService(
        IFreeSqlRepository<UserTag> tagRepository,
        IFreeSqlRepository<UserInTag> userTagRepository)
    {
        this.tagRepository = tagRepository;
        this.userTagRepository = userTagRepository;
    }

    public async Task<List<UserTagListOutput>> GetAllTagsAsync()
    {
        var tags = await tagRepository.Select
            .OrderBy(x => new { x.Sort, x.CreationTime })
            .ToListAsync();

        var result = new List<UserTagListOutput>();
        foreach (var tag in tags)
        {
            var userCount = await userTagRepository.Select.Where(x => x.TagId == tag.Id).CountAsync();
            result.Add(new UserTagListOutput
            {
                Id = tag.Id,
                Name = tag.Name,
                Color = tag.Color,
                Sort = tag.Sort,
                UserCount = (int)userCount
            });
        }

        return result;
    }

    [BusinessLog("用户标签管理", BusinessOperateType.Create, "创建标签{{Name}}")]
    public async Task<Guid> CreateTagAsync(UserTagCreateInput input)
    {
        var isExist = await tagRepository.Select.AnyAsync(x => x.Name.ToLower() == input.Name.ToLower());
        if (isExist)
        {
            throw HttpFriendlyException.BadRequest($"标签名{input.Name}已存在");
        }

        var maxSort = await tagRepository.Select.MaxAsync(x => x.Sort);
        var entity = new UserTag(GuidGenerator.Create(), input.Name)
        {
            Name = input.Name,
            Color = input.Color ?? "#1890ff",
            Sort = maxSort + 1
        };

        entity = await tagRepository.InsertAsync(entity);

        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddVariable("EntityId", entity.Id);

        return entity.Id;
    }

    [BusinessLog("用户标签管理", BusinessOperateType.Update, "更新标签{{Name}}")]
    public async Task<bool> UpdateTagAsync(Guid id, UserTagUpdateInput input)
    {
        var entity = await tagRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound($"标签ID:{id}不存在");

        var isExist = await tagRepository.Select
            .Where(x => x.Name.ToLower() == input.Name.ToLower() && x.Id != id)
            .AnyAsync();
        if (isExist)
        {
            throw HttpFriendlyException.BadRequest($"标签名{input.Name}已存在");
        }

        entity.Name = input.Name;
        entity.Color = input.Color ?? "#1890ff";

        await tagRepository.UpdateAsync(entity);

        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddVariable("EntityId", id);

        return true;
    }

    [BusinessLog("用户标签管理", BusinessOperateType.Delete, "删除标签{{Name}}")]
    public async Task<bool> DeleteTagAsync(Guid id)
    {
        var hasUsers = await userTagRepository.Select.AnyAsync(x => x.TagId == id);
        if (hasUsers)
        {
            throw HttpFriendlyException.BadRequest("标签已分配给用户，不能删除");
        }

        var tag = await tagRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound($"标签ID:{id}不存在");

        await tagRepository.DeleteAsync(x => x.Id == id);

        BusinessLogManager.Current?.AddVariable("Name", tag.Name);
        BusinessLogManager.Current?.AddVariable("EntityId", id);

        return true;
    }

    public async Task<List<SelectOption>> GetTagSelectOptionsAsync()
    {
        return await tagRepository.Select
            .OrderBy(x => new { x.Sort, x.Name })
            .ToListAsync(x => new SelectOption
            {
                Label = x.Name,
                Value = x.Id.ToString()
            });
    }
}