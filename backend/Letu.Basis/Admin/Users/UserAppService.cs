using Letu.Applications;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.SharedService;
using Letu.Logging;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Enums;
using Letu.Shared.Generated;
using Letu.Utils;
using Volo.Abp;
using Volo.Abp.Application.Services;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;

namespace Letu.Basis.Admin.Users
{
    public class UserAppService : BasisAppService, IUserAppService
    {
        private readonly IFreeSqlRepository<User> _userRepository;
        private readonly IFreeSqlRepository<UserInRole> _userRoleRepository;
        private readonly IdentitySharedService _identityDomainService;
        private readonly IOperationLogManager operationLogManager;
        private readonly IDistributedEventBus eventBus;
        public UserAppService(IFreeSqlRepository<User> userRepository,
            IFreeSqlRepository<UserInRole> userRoleRepository,
            IdentitySharedService identityDomainService,
            IOperationLogManager operationLogManager,
            IDistributedEventBus eventBus)
        {
            _userRepository = userRepository;
            _userRoleRepository = userRoleRepository;
            _identityDomainService = identityDomainService;
            this.operationLogManager = operationLogManager;
            this.eventBus = eventBus;
        }

        public async Task<Guid> AddUserAsync(UserCreateOrUpdateInput dto)
        {
            var isExist = await _userRepository.Select.AnyAsync(x => x.UserName.ToLower() == dto.UserName.ToLower());
            if (isExist)
            {
                throw new BusinessException(message: "账号已存在");
            }
            if (!RegexCodeGen.Password().IsMatch(dto.Password))
            {
                throw new BusinessException(message: "密码格式不正确");
            }
            var user = new User(GuidGenerator.Create())
            {
                UserName = dto.UserName,
                PasswordSalt = EncryptionUtils.GetPasswordSalt(),
                Avatar = dto.Avatar,
                NickName = dto.NickName ?? dto.UserName,
                Sex = dto.Sex,
                Phone = dto.Phone,
                IsEnabled = true
            };
            if (string.IsNullOrWhiteSpace(dto.Avatar))
            {
                user.Avatar = user.Sex == SexType.Male ? AdminConsts.AvatarMale : AdminConsts.AvatarFemale;
            }
            user.Password = EncryptionUtils.CalcPasswordHash(dto.Password, user.PasswordSalt);
            user = await _userRepository.InsertAsync(user);
            return user.Id;
        }

        public async Task<bool> AssignRoleAsync(Guid userId, AssignRoleDto input)
        {
            await _userRoleRepository.DeleteAsync(x => x.UserId == userId);
            if (input.RoleIds != null)
            {
                var items = new List<UserInRole>();
                foreach (var item in input.RoleIds)
                {
                    items.Add(new UserInRole
                    {
                        UserId = userId,
                        RoleId = item
                    });
                }
                if (items.Count > 0)
                {
                    await _userRoleRepository.InsertAsync(items);
                }
            }
            return true;
        }

        public async Task<bool> DeleteUserAsync(Guid id)
        {
            if (CurrentUser.Id == id)
            {
                throw new BusinessException(message: "不能删除自己");
            }
            var user = await _userRepository.Where(x => x.Id == id).FirstAsync();
            await _userRepository.DeleteAsync(x => x.Id == id);
            await _identityDomainService.RemoveUserPermissionCacheByUserIdAsync(id);

            var userDeleteEto = new EntityDeletedEto<UserEto>(new UserEto()
            {
                Id = id,
                UserName = user.UserName,
                TenantId = user.TenantId,
                Name = user.NickName,
                IsActive = user.IsEnabled
            });

            await eventBus.PublishAsync(userDeleteEto);

            return true;
        }

        public async Task<PagedResult<UserListOutput>> GetUserListAsync(UserListInput dto)
        {
            var rows = await _userRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName.Contains(dto.UserName!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<UserListOutput>();

            return new PagedResult<UserListOutput>(total, rows);
        }

        public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
        {
            return [.. await _userRoleRepository.Where(x => x.UserId == uid).ToListAsync(x => x.RoleId)];
        }

        public async Task<bool> SwitchUserEnabledStatusAsync(Guid id)
        {
            var entity = await _userRepository.Where(x => x.Id == id).FirstAsync()
                ?? throw new BusinessException(message: "数据不存在");
            entity.IsEnabled = !entity.IsEnabled;
            await _userRepository.UpdateAsync(entity);

            if (!entity.IsEnabled)
            {
                await _identityDomainService.RemoveUserPermissionCacheByUserIdAsync(id);
            }
            return true;
        }

        [OperationLog(LogRecordConsts.SysUser, LogRecordConsts.SysUserResetPwdSubType, "{{id}}", LogRecordConsts.SysUserResetPwdContent)]
        public async Task ResetUserPasswordAsync(ResetUserPwdDto dto)
        {
            var user = await _userRepository.Where(x => x.Id == dto.UserId).FirstAsync();
            if (!RegexCodeGen.Password().IsMatch(dto.Password))
            {
                throw new BusinessException(message: "密码格式不正确");
            }

            user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
            user.Password = EncryptionUtils.CalcPasswordHash(dto.Password!, user.PasswordSalt);
            await _userRepository.UpdateAsync(user);

            operationLogManager.Current?.AddVariable("id", user.Id);
            operationLogManager.Current?.AddVariable("userName", user.UserName);
        }

        public Task<List<UserSimpleInfoDto>> GetUserSimpleInfosAsync(string? keyword)
        {
            return _userRepository.Where(x => x.IsEnabled)
                .WhereIf(!string.IsNullOrEmpty(keyword), x => x.UserName.Contains(keyword!) || x.NickName.Contains(keyword!))
                .OrderBy(x => x.NickName)
                .ToListAsync<UserSimpleInfoDto>();
        }
    }
}