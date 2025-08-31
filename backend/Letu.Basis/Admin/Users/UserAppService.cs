using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Utils;
using Letu.Logging;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Generated;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;

namespace Letu.Basis.Admin.Users
{
    public class UserAppService : BasisAppService, IUserAppService
    {
        private readonly IFreeSqlRepository<User> userRepository;
        private readonly IFreeSqlRepository<UserInRole> _userRoleRepository;
        private readonly IOperationLogManager operationLogManager;
        private readonly IDistributedEventBus eventBus;
        public UserAppService(IFreeSqlRepository<User> userRepository,
            IFreeSqlRepository<UserInRole> userRoleRepository,
            IOperationLogManager operationLogManager,
            IDistributedEventBus eventBus)
        {
            this.userRepository = userRepository;
            _userRoleRepository = userRoleRepository;
            this.operationLogManager = operationLogManager;
            this.eventBus = eventBus;
        }

        public async Task<Guid> AddUserAsync(UserCreateInput input)
        {
            await CheckUserExists(input.UserName, input.Phone, input.Email);

            //TODO: 通过设置的密码强度策略来校验
            if (!RegexCodeGen.Password().IsMatch(input.Password))
            {
                throw HttpFriendlyException.BadRequest("密码格式不正确");
            }

            var salt = EncryptionUtils.GetPasswordSalt();
            var user = new User(GuidGenerator.Create(), input.UserName)
            {
                PasswordSalt = salt,
                PasswordHash = EncryptionUtils.CalcPasswordHash(input.Password, salt),
                NickName = input.NickName,
                IsEnabled = true
            };

            ObjectMapper.Map(input, user);

            if (string.IsNullOrWhiteSpace(input.Avatar))
            {
                user.Avatar = AdminConsts.AvatarMale;
            }
            user = await userRepository.InsertAsync(user);
            return user.Id;
        }

        public async Task<Guid> UpdateUserAsync(Guid id, UserUpdateInput input)
        {
            await CheckUserExists(null, input.Phone, input.Email, id);

            var user = await userRepository.Where(x => x.Id == id).FirstAsync()
                ?? throw HttpFriendlyException.NotFound($"用户ID:{id}不存在。");
            ObjectMapper.Map(input, user);
            await userRepository.UpdateAsync(user);

            return user.Id;
        }

        private async Task CheckUserExists(string? userName, string? phone, string? email, Guid? excludeId = null)
        {
            System.Linq.Expressions.Expression<Func<User, bool>> condition = u => false; // 初始化为一个假条件

            if (!string.IsNullOrEmpty(userName))
            {
                var lowerName = userName.ToLower(); // 预先转换为小写
                condition = condition.Or(u => u.UserName.ToLower() == lowerName);
            }

            if (!string.IsNullOrWhiteSpace(phone))
            {
                var lowerPhone = phone.ToLower();
                condition = condition.Or(u => u.Phone.ToLower() == lowerPhone);
            }

            if (!string.IsNullOrWhiteSpace(email))
            {
                var lowerEmail = email.ToLower();
                condition = condition.Or(u => u.Email.ToLower() == lowerEmail);
            }

            var existUser = await userRepository.Select
                .Where(condition)
                .WhereIf(excludeId.HasValue, u => u.Id != excludeId!.Value)
                .FirstAsync();

            if (existUser != null)
            {
                if (userName == existUser.UserName)
                    throw HttpFriendlyException.BadRequest($"账号{userName}已存在");

                if (!string.IsNullOrWhiteSpace(email) && email == existUser.Email)
                    throw HttpFriendlyException.BadRequest($"邮箱{email}已存在");

                if (!string.IsNullOrWhiteSpace(phone) && phone == existUser.Phone)
                    throw HttpFriendlyException.BadRequest($"手机号{phone}已存在");
            }
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
                throw HttpFriendlyException.BadRequest("不能删除自己");
            }
            var user = await userRepository.Where(x => x.Id == id).FirstAsync();
            await userRepository.DeleteAsync(x => x.Id == id);

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
            var rows = await userRepository.Select
                .From<Departments.Department, Positions.PositionGroup, Employee>((u, d, p, e) => u
                    .LeftJoin(u1 => u1.DepartmentId == d.Id)
                    .LeftJoin(u1 => u1.PositionId == p.Id)
                    .LeftJoin(u1 => u1.EmployeeId == e.Id))
                .WhereIf(!string.IsNullOrEmpty(dto.UserName), (u, d, p, e) => u.UserName.Contains(dto.UserName!))
                .OrderByDescending((u, d, p, e) => u.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync((u, d, p, e) => new UserListOutput
                {
                    Id = u.Id,
                    UserName = u.UserName,
                    Avatar = u.Avatar,
                    NickName = u.NickName,
                    IsEnabled = u.IsEnabled,
                    Phone = u.Phone,
                    Email = u.Email,
                    DepartmentId = u.DepartmentId,
                    DepartmentName = d.Name,
                    PositionId = u.PositionId,
                    PositionName = p.GroupName,
                    EmployeeId = u.EmployeeId,
                    EmployeeName = e.Name
                });

            return new PagedResult<UserListOutput>(total, rows);
        }

        public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
        {
            return [.. await _userRoleRepository.Where(x => x.UserId == uid).ToListAsync(x => x.RoleId)];
        }

        public async Task<bool> SwitchUserEnabledStatusAsync(Guid id)
        {
            var entity = await userRepository.Where(x => x.Id == id).FirstAsync()
                ?? throw HttpFriendlyException.NotFound("数据不存在");
            entity.IsEnabled = !entity.IsEnabled;
            await userRepository.UpdateAsync(entity);

            // TODO: 启用用户时发出Event通知？

            return true;
        }

        [OperationLog(LogRecordConsts.SysUser, LogRecordConsts.SysUserResetPwdSubType, "{{id}}", LogRecordConsts.SysUserResetPwdContent)]
        public async Task ResetUserPasswordAsync(ResetUserPwdDto dto)
        {
            var user = await userRepository.Where(x => x.Id == dto.UserId).FirstAsync();
            if (!RegexCodeGen.Password().IsMatch(dto.Password))
            {
                throw HttpFriendlyException.BadRequest("密码格式不正确");
            }

            user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
            user.PasswordHash = EncryptionUtils.CalcPasswordHash(dto.Password!, user.PasswordSalt);
            await userRepository.UpdateAsync(user);

            operationLogManager.Current?.AddVariable("id", user.Id);
            operationLogManager.Current?.AddVariable("userName", user.UserName);
        }

        public async Task<List<SelectOption>> GetUserSelectOptionsByIdsAsync(List<Guid> userIds)
        {
            if (userIds == null || userIds.Count == 0)
            {
                return [];
            }

            return await userRepository.Select
                .Where(x => userIds.Contains(x.Id))
                .OrderBy(x => x.UserName)
                .ToListAsync(x => new SelectOption
                {
                    Label = $"{x.UserName} {x.NickName}",
                    Value = x.Id.ToString()
                });
        }


        public Task<List<SelectOption>> GetUserSelectOptionsAsync(string? keyword)
        {
            return userRepository.Where(x => x.IsEnabled)
                .WhereIf(!string.IsNullOrEmpty(keyword), x => x.UserName.Contains(keyword!) || x.NickName.Contains(keyword!))
                .Limit(50)
                .OrderBy(x => x.UserName)
                .ToListAsync(x => new SelectOption { Value = x.Id.ToString(), Label = $"{x.UserName} {x.NickName}" });
        }
    }
}