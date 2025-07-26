using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.SharedService;
using Letu.Core.Interfaces;
using Letu.Core.Utils;
using Letu.Logger;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Enums;
using Letu.Shared.Generated;

namespace Letu.Basis.Admin.Users
{
    public class UserService : IUserService
    {
        private readonly IRepository<User> _userRepository;
        private readonly IRepository<UserInRole> _userRoleRepository;
        private readonly IdentitySharedService _identityDomainService;
        private readonly ICurrentUser _currentUser;

        public UserService(IRepository<User> userRepository, IRepository<UserInRole> userRoleRepository
            , IdentitySharedService identityDomainService, ICurrentUser currentUser)
        {
            _userRepository = userRepository;
            _userRoleRepository = userRoleRepository;
            _identityDomainService = identityDomainService;
            _currentUser = currentUser;
        }

        public async Task<Guid> AddUserAsync(UserDto dto)
        {
            var isExist = await _userRepository.Select.AnyAsync(x => x.UserName.ToLower() == dto.UserName.ToLower());
            if (isExist)
            {
                throw new BusinessException("账号已存在");
            }
            if (!RegexCodeGen.Password().IsMatch(dto.Password))
            {
                throw new BusinessException("密码格式不正确");
            }
            var user = new User
            {
                Id = Guid.NewGuid(),
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
            user.Password = EncryptionUtils.GenEncodingPassword(dto.Password, user.PasswordSalt);
            await _userRepository.InsertAsync(user);
            return user.Id;
        }

        public async Task<bool> AssignRoleAsync(AssignRoleDto dto)
        {
            await _userRoleRepository.DeleteAsync(x => x.UserId == dto.UserId);
            if (dto.RoleIds != null)
            {
                var items = new List<UserInRole>();
                foreach (var item in dto.RoleIds)
                {
                    items.Add(new UserInRole
                    {
                        UserId = dto.UserId,
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
            if (_currentUser.Id == id)
            {
                throw new BusinessException("不能删除自己");
            }
            await _userRepository.DeleteAsync(x => x.Id == id);
            await _identityDomainService.DelUserPermissionCacheByUserIdAsync(id);
            return true;
        }

        public async Task<PagedResult<UserListDto>> GetUserListAsync(UserQueryDto dto)
        {
            var rows = await _userRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName.Contains(dto.UserName!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<UserListDto>();

            return new PagedResult<UserListDto>(total, rows);
        }

        public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
        {
            return [.. await _userRoleRepository.Where(x => x.UserId == uid).ToListAsync(x => x.RoleId)];
        }

        public async Task<bool> SwitchUserEnabledStatusAsync(Guid id)
        {
            var entity = await _userRepository.Where(x => x.Id == id).FirstAsync()
                ?? throw new BusinessException("数据不存在");
            entity.IsEnabled = !entity.IsEnabled;
            await _userRepository.UpdateAsync(entity);

            if (!entity.IsEnabled)
            {
                await _identityDomainService.DelUserPermissionCacheByUserIdAsync(id);
            }
            return true;
        }

        [AsyncLogRecord(LogRecordConsts.SysUser, LogRecordConsts.SysUserResetPwdSubType, "{{id}}", LogRecordConsts.SysUserResetPwdContent)]
        public async Task ResetUserPasswordAsync(ResetUserPwdDto dto)
        {
            var user = await _userRepository.Where(x => x.Id == dto.UserId).FirstAsync();
            if (!RegexCodeGen.Password().IsMatch(dto.Password))
            {
                throw new BusinessException("密码格式不正确");
            }

            user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
            user.Password = EncryptionUtils.GenEncodingPassword(dto.Password!, user.PasswordSalt);
            await _userRepository.UpdateAsync(user);

            LogRecordContext.PutVariable("id", user.Id);
            LogRecordContext.PutVariable("userName", user.UserName);
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