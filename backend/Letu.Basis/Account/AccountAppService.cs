using FreeSql;
using Letu.Basis.Account.Dtos;
using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Users;
using Letu.Basis.SharedService;
using Letu.Repository;
using Letu.Shared.Enums;
using Letu.Shared.Models;
using Letu.Utils;
using Volo.Abp;
using Volo.Abp.Application.Services;
using Volo.Abp.EventBus.Local;
using Volo.Abp.Users;

namespace Letu.Basis.Account
{
    public class AccountAppService : ApplicationService, IAccountAppService
    {
        private readonly IFreeSqlRepository<User> userRepository;
        private readonly IFreeSqlRepository<MenuItem> menuRepository;
        private readonly IdentitySharedService identitySharedService;

        public AccountAppService(
            IFreeSqlRepository<User> userRepository,
            IFreeSqlRepository<MenuItem> menuRepository,
            ILocalEventBus localEventBus,
            IdentitySharedService identitySharedService)
        {
            this.userRepository = userRepository;
            this.menuRepository = menuRepository;
            this.identitySharedService = identitySharedService;
        }

        public async Task<UserAuthInfoOutput> GetUserAuthInfoAsync()
        {
            var uid = CurrentUser.Id!.Value;
            var user = await userRepository.Where(x => x.Id == uid).FirstAsync() ?? throw new BusinessException(message: "用户不存在");
            var permission = await identitySharedService.GetUserPermissionAsync(uid);
            UserAuthInfoOutput result = new()
            {
                User = new UserInfoOutput
                {
                    SessionId = CurrentUser.GetSessionId(),
                    UserId = user.Id,
                    UserName = user.UserName,
                    NickName = user.NickName,
                    Avatar = user.Avatar,
                    Sex = (int)user.Sex,
                },
                Menus = await GetFrontMenus(),
                Permissions = permission.Auths ?? []
            };
            return result;
        }

        public async Task<List<FrontendMenu>> GetFrontMenus()
        {
            var uid = CurrentUser.Id!.Value;
            var permission = await identitySharedService.GetUserPermissionAsync(uid);
            if (permission.MenuIds == null || permission.MenuIds.Length <= 0) return [];

            var all = await menuRepository
                .Where(x => permission.MenuIds.Contains(x.Id) && (x.MenuType == MenuType.Menu || x.MenuType == MenuType.Folder)).ToListAsync();
            var top = all.Where(x => !x.ParentId.HasValue || x.ParentId == Guid.Empty).OrderBy(x => x.Sort).ToList();
            var topMap = new List<FrontendMenu>();
            foreach (var item in top)
            {
                var mapItem = ObjectMapper.Map<MenuItem, FrontendMenu>(item);
                mapItem.LayerName = item.Title;
                mapItem.Children = getChildren(mapItem);
                topMap.Add(mapItem);
            }

            List<FrontendMenu>? getChildren(FrontendMenu current)
            {
                var children = all.Where(x => x.ParentId == current.Id).OrderBy(x => x.Sort).ToList();
                if (children.Count <= 0) return null;

                var childrenMap = new List<FrontendMenu>();
                foreach (var item in children)
                {
                    var mapItem = ObjectMapper.Map<MenuItem, FrontendMenu>(item);
                    mapItem.LayerName = current.LayerName + "/" + item.Title;
                    mapItem.Children = getChildren(mapItem);
                    childrenMap.Add(mapItem);
                }
                return childrenMap;
            }
            return topMap;
        }

        public async Task<bool> UpdateUserInfoAsync(UserInfoUpdateInput dto)
        {
            var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync();
            if (!string.IsNullOrEmpty(dto.NickName))
            {
                if (user.NickName.ToLower() != dto.NickName!.ToLower())
                {
                    var exist = await userRepository.Where(x => x.NickName.ToLower() == dto.NickName.ToLower()).AnyAsync();
                    if (exist) throw new BusinessException(message: "昵称已占用");
                }
                user.NickName = dto.NickName;
            }
            if (!string.IsNullOrEmpty(dto.Avatar))
            {
                user.Avatar = dto.Avatar;
            }
            if (dto.Sex > 0)
            {
                user.Sex = dto.Sex;
            }
            await userRepository.UpdateAsync(user);
            return true;
        }

        public async Task<bool> UpdateUserPwdAsync(ChangePasswordInput dto)
        {
            var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync()
                ?? throw new BusinessException(message: "用户不存在");
            var isRight = user.Password == EncryptionUtils.CalcPasswordHash(dto.OldPwd, user.PasswordSalt);
            if (!isRight) throw new BusinessException(message: "旧密码错误");
            user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
            user.Password = EncryptionUtils.CalcPasswordHash(dto.NewPwd, user.PasswordSalt);
            await userRepository.UpdateAsync(user);
            return true;
        }
    }
}