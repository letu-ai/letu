using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.SharedService;
using Letu.Repository;
using Letu.Shared.Consts;

namespace Letu.Basis.Admin.Roles
{
    public class RoleService : IRoleService
    {
        private readonly IRepository<Role> _roleRepository;
        private readonly IRepository<MenuInRole> _roleMenuRepository;
        private readonly IRepository<UserInRole> _userRoleRepository;
        private readonly IdentitySharedService _identitySharedService;

        public RoleService(IRepository<Role> roleRepository, IRepository<MenuInRole> roleMenuRepository
            , IRepository<UserInRole> userRoleRepository, IdentitySharedService identitySharedService)
        {
            _roleRepository = roleRepository;
            _roleMenuRepository = roleMenuRepository;
            _userRoleRepository = userRoleRepository;
            _identitySharedService = identitySharedService;
        }

        public async Task<bool> AddRoleAsync(RoleDto dto)
        {
            var isExist = await _roleRepository.Select.AnyAsync(x => x.RoleName.ToLower() == dto.RoleName.ToLower());
            if (isExist)
            {
                throw new BusinessException("角色名已存在");
            }
            var entity = new Role
            {
                RoleName = dto.RoleName,
                Remark = dto.Remark
            };
            await _roleRepository.InsertAsync(entity);
            return true;
        }

        public async Task<bool> AssignMenuAsync(AssignMenuDto dto)
        {
            await _roleMenuRepository.DeleteAsync(x => x.RoleId == dto.RoleId);
            if (dto.MenuIds != null)
            {
                var items = new List<MenuInRole>();
                foreach (var item in dto.MenuIds)
                {
                    items.Add(new MenuInRole
                    {
                        RoleId = dto.RoleId,
                        MenuId = item
                    });
                }
                if (items.Count > 0)
                {
                    await _roleMenuRepository.InsertAsync(items);
                }
            }

            await _identitySharedService.DelUserPermissionCacheByRoleIdAsync(dto.RoleId);
            return true;
        }

        public async Task<bool> DeleteRoleAsync(Guid id)
        {
            var hasUsers = await _userRoleRepository.Select.AnyAsync(x => x.RoleId == id);
            if (hasUsers) throw new BusinessException(message: "角色已分配给用户，不能删除");

            var role = await _roleRepository.Where(x => x.Id == id).FirstAsync();
            if (role.RoleName == AdminConsts.SuperAdminRole)
            {
                throw new BusinessException(message: $"{role.RoleName}不能删除");
            }
            await _roleRepository.DeleteAsync(x => x.Id == id);
            await _identitySharedService.DelUserPermissionCacheByRoleIdAsync(id);
            return true;
        }

        public async Task<PagedResult<RoleListDto>> GetRoleListAsync(RoleQueryDto dto)
        {
            var rows = await _roleRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.RoleName), x => x.RoleName.Contains(dto.RoleName!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<RoleListDto>();

            return new PagedResult<RoleListDto>(total, rows);
        }

        public async Task<List<AppOption>> GetRoleOptionsAsync()
        {
            return await _roleRepository.Select.ToListAsync(x => new AppOption
            {
                Label = x.RoleName,
                Value = x.Id.ToString()
            });
        }

        public async Task<bool> UpdateRoleAsync(RoleDto dto)
        {
            if (!dto.Id.HasValue) throw new ArgumentNullException(nameof(dto.Id));
            var entity = await _roleRepository.Where(x => x.Id == dto.Id).FirstAsync()
                ?? throw new BusinessException("数据不存在");
            var isExist = await _roleRepository.Select.AnyAsync(x => x.RoleName.ToLower() == dto.RoleName.ToLower());
            if (entity.RoleName.ToLower() != dto.RoleName.ToLower() && isExist)
            {
                throw new BusinessException("角色名已存在");
            }
            if (entity.RoleName == AdminConsts.SuperAdminRole)
            {
                throw new BusinessException(message: $"{entity.RoleName}不允许编辑");
            }
            entity.RoleName = dto.RoleName;
            entity.Remark = dto.Remark;
            entity.IsEnabled = dto.IsEnabled;
            await _roleRepository.UpdateAsync(entity);

            if (!entity.IsEnabled)
            {
                await _identitySharedService.DelUserPermissionCacheByRoleIdAsync(entity.Id);
            }
            return true;
        }

        public async Task<Guid[]> GetRoleMenuIdsAsync(Guid id)
        {
            return [.. await _roleMenuRepository.Where(x => x.RoleId == id).ToListAsync(x => x.MenuId)];
        }
    }
}