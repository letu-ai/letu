using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Letu.Shared.Consts;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;

namespace Letu.Basis.Admin.Roles;

public class RoleAppService : BasisAppService, IRoleAppService
{
    private readonly IFreeSqlRepository<Role> _roleRepository;
    private readonly IFreeSqlRepository<MenuInRole> _roleMenuRepository;
    private readonly IFreeSqlRepository<UserInRole> _userRoleRepository;
    private readonly IDistributedEventBus eventBus;

    public RoleAppService(
        IFreeSqlRepository<Role> roleRepository,
        IFreeSqlRepository<MenuInRole> roleMenuRepository,
        IFreeSqlRepository<UserInRole> userRoleRepository,
        IDistributedEventBus eventBus
        )
    {
        _roleRepository = roleRepository;
        _roleMenuRepository = roleMenuRepository;
        _userRoleRepository = userRoleRepository;
        this.eventBus = eventBus;
    }

    public async Task<bool> AddRoleAsync(RoleCreateOrUpdateInput dto)
    {
        var isExist = await _roleRepository.Select.AnyAsync(x => x.Name.ToLower() == dto.Name.ToLower());
        if (isExist)
        {
            throw HttpFriendlyException.BadRequest($"角色名{dto.Name}已存在");
        }
        var entity = new Role
        {
            Name = dto.Name,
            Remark = dto.Remark
        };
        await _roleRepository.InsertAsync(entity);
        return true;
    }

    public async Task<bool> DeleteRoleAsync(Guid id)
    {
        var hasUsers = await _userRoleRepository.Select.AnyAsync(x => x.RoleId == id);
        if (hasUsers) throw HttpFriendlyException.BadRequest("角色已分配给用户，不能删除");

        var role = await _roleRepository.Where(x => x.Id == id).FirstAsync();
        if (role.Name == AdminConsts.SuperAdminRole)
        {
            throw HttpFriendlyException.BadRequest($"{role.Name}不能删除");
        }
        await _roleRepository.DeleteAsync(x => x.Id == id);

        var roleDeleteEto = new EntityDeletedEto<RoleEto>(new RoleEto()
        {
            Id = role.Id,
            Name = role.Name,
            TenantId = role.TenantId,
        });
        await eventBus.PublishAsync(roleDeleteEto);

        return true;
    }

    public async Task<PagedResult<RoleListOutput>> GetRoleListAsync(RoleListInput dto)
    {
        var rows = await _roleRepository.Select
            .WhereIf(!string.IsNullOrEmpty(dto.Name), x => x.Name.Contains(dto.Name!))
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync<RoleListOutput>();

        return new PagedResult<RoleListOutput>(total, rows);
    }

    public async Task<List<SelectOption>> GetRoleOptionsAsync()
    {
        return await _roleRepository.Select.ToListAsync(x => new SelectOption
        {
            Label = x.Name,
            Value = x.Id.ToString()
        });
    }

    public async Task<bool> UpdateRoleAsync(Guid id, RoleCreateOrUpdateInput input)
    {
        var entity = await _roleRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw new EntityNotFoundException(typeof(Role), id);

        var isExist = await _roleRepository.Select.AnyAsync(x => x.Name.ToLower() == input.Name.ToLower());
        if (entity.Name.ToLower() != input.Name.ToLower() && isExist)
        {
            throw HttpFriendlyException.BadRequest($"角色名{input.Name}已存在");
        }
        if (entity.Name == AdminConsts.SuperAdminRole)
        {
            throw HttpFriendlyException.BadRequest($"{entity.Name}不允许编辑");
        }

        RoleNameChangedEto? roleNameChangedEto = null;
        if (entity.Name != input.Name)
        {
            roleNameChangedEto = new RoleNameChangedEto
            {
                Id = entity.Id,
                OldName = entity.Name,
                Name = input.Name,
                TenantId = entity.TenantId
            };
        }

        entity.Name = input.Name;
        entity.Remark = input.Remark;
        entity.IsEnabled = input.IsEnabled;
        await _roleRepository.UpdateAsync(entity);

        if (roleNameChangedEto != null)
            await eventBus.PublishAsync(roleNameChangedEto);

        if (!entity.IsEnabled)
        {
            // TODO: 禁用角色时发出Event通知？
        }
        return true;
    }

    public async Task<Guid[]> GetRoleMenuIdsAsync(Guid id)
    {
        return [.. await _roleMenuRepository.Where(x => x.RoleId == id).ToListAsync(x => x.MenuId)];
    }
}