using Fancyx.Admin.Entities.System;
using Fancyx.Admin.IService.System;
using Fancyx.Admin.IService.System.Dtos;
using Fancyx.Admin.SharedService;
using Fancyx.Repository;
using Fancyx.Shared.Consts;

namespace Fancyx.Admin.Service.System
{
    public class RoleService : IRoleService
    {
        private readonly IRepository<RoleDO> _roleRepository;
        private readonly IRepository<RoleMenuDO> _roleMenuRepository;
        private readonly IRepository<UserRoleDO> _userRoleRepository;
        private readonly IdentitySharedService _identityDomainService;
        private readonly IRepository<RoleDeptDO> _roleDeptRepository;

        public RoleService(IRepository<RoleDO> roleRepository, IRepository<RoleMenuDO> roleMenuRepository
            , IRepository<UserRoleDO> userRoleRepository, IdentitySharedService identityDomainService, IRepository<RoleDeptDO> roleDeptRepository)
        {
            _roleRepository = roleRepository;
            _roleMenuRepository = roleMenuRepository;
            _userRoleRepository = userRoleRepository;
            _identityDomainService = identityDomainService;
            _roleDeptRepository = roleDeptRepository;
        }

        public async Task<bool> AddRoleAsync(RoleDto dto)
        {
            var isExist = await _roleRepository.Select.AnyAsync(x => x.RoleName.ToLower() == dto.RoleName.ToLower());
            if (isExist)
            {
                throw new BusinessException("角色名已存在");
            }
            var entity = new RoleDO
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
                var items = new List<RoleMenuDO>();
                foreach (var item in dto.MenuIds)
                {
                    items.Add(new RoleMenuDO
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
            await _identityDomainService.DelUserPermissionCacheByRoleIdAsync(dto.RoleId);
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
            return true;
        }

        public async Task<PagedResult<RoleListDto>> GetRoleListAsync(RoleQueryDto dto)
        {
            var rows = await _roleRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.RoleName), x => x.RoleName.Contains(dto.RoleName!))
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
            await _roleRepository.UpdateAsync(entity);
            return true;
        }

        public async Task<Guid[]> GetRoleMenuIdsAsync(Guid id)
        {
            return [.. await _roleMenuRepository.Where(x => x.RoleId == id).ToListAsync(x => x.MenuId)];
        }

        public async Task AssignDataAsync(AssignDataDto dto)
        {
            var role = await _roleRepository.Where(x => x.Id == dto.RoleId).FirstAsync();
            role.PowerDataType = dto.PowerDataType;
            if (dto.PowerDataType == 1)
            {
                if (dto.DeptIds == null || dto.DeptIds.Length <= 0)
                {
                    throw new BusinessException(message: "请选择指定部门");
                }
                var list = new List<RoleDeptDO>();
                foreach (var item in dto.DeptIds)
                {
                    list.Add(new RoleDeptDO { RoleId = dto.RoleId, DeptId = item });
                }
                await _roleDeptRepository.InsertAsync(list);
            }
            else
            {
                await _roleDeptRepository.DeleteAsync(x => x.RoleId == dto.RoleId);
            }
        }

        public async Task<AssignDataResultDto> GetRolePowerDataAsync(Guid id)
        {
            var role = await _roleRepository.Where(x => x.Id == id).FirstAsync();
            var result = new AssignDataResultDto
            {
                PowerDataType = role.PowerDataType
            };
            if (result.PowerDataType == 1)
            {
                result.DeptIds = (await _roleDeptRepository.Where(x => x.RoleId == id).ToListAsync(x => x.DeptId))
                    .ToArray();
            }
            return result;
        }
    }
}