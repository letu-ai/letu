using FreeSql;
using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Enums;
using Letu.Shared.Keys;
using Letu.Shared.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Volo.Abp.Caching;
using Volo.Abp.DependencyInjection;

namespace Letu.Basis.SharedService
{
    public class IdentitySharedService : ITransientDependency
    {
        private readonly IFreeSqlRepository<UserInRole> _userRoleRepository;
        private readonly IFreeSqlRepository<MenuInRole> _roleMenuRepository;
        private readonly IFreeSqlRepository<Role> _roleRepository;
        private readonly IFreeSqlRepository<MenuItem> _menuRepository;
        private readonly IConfiguration _configuration;
        private readonly IFreeSqlRepository<User> _userRepository;
        private readonly IDistributedCache<UserPermission> permissionCache;
        private readonly IDistributedCache<string> _accessTokenCache;
        private readonly IDistributedCache<string> _refreshTokenCache;

        public IdentitySharedService(IFreeSqlRepository<UserInRole> userRoleRepository,
            IFreeSqlRepository<MenuInRole> roleMenuRepository,
            IFreeSqlRepository<Role> roleRepository,
            IFreeSqlRepository<MenuItem> menuRepository,
            IConfiguration configuration,
            IFreeSqlRepository<User> userRepository,
            IDistributedCache<UserPermission> permissionCache,
            IDistributedCache<string> accessTokenCache,
            IDistributedCache<string> refreshTokenCache)
        {
            _userRoleRepository = userRoleRepository;
            _roleMenuRepository = roleMenuRepository;
            _roleRepository = roleRepository;
            _menuRepository = menuRepository;
            _configuration = configuration;
            _userRepository = userRepository;
            this.permissionCache = permissionCache;
            _accessTokenCache = accessTokenCache;
            _refreshTokenCache = refreshTokenCache;
        }

        /// <summary>
        /// 获取用户权限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<UserPermission> GetUserPermissionAsync(Guid userId)
        {
            var key = SystemCacheKey.UserPermission(userId);
            var cacheValue = await permissionCache.GetAsync(key);
            if (cacheValue != null)
            {
                return cacheValue!;
            }

            var roleIds = await _userRoleRepository.Where(x => x.UserId == userId).ToListAsync(x => x.RoleId);
            var roles = await _roleRepository.Where(x => roleIds.Contains(x.Id) && x.IsEnabled).ToListAsync();
            var isSuperAdmin = roles.Any(r => r.Name == AdminConsts.SuperAdminRole);
            var menuIds = await _roleMenuRepository.Where(x => roleIds.Contains(x.RoleId)).ToListAsync(x => x.MenuId);
            var menus = await _menuRepository.Select.Where(x => menuIds.Contains(x.Id) || isSuperAdmin).ToListAsync(x => new { x.Permission, x.Id, x.MenuType });
            if (isSuperAdmin)
            {
                menuIds = menus.Select(x => x.Id).ToList();
            }
            var rs = new UserPermission
            {
                UserId = userId,
                Roles = roles.Select(c => c.Name).ToArray(),
                Auths = menus.Where(c => !string.IsNullOrEmpty(c.Permission) && c.MenuType == MenuType.Button).Select(c => c.Permission!).Distinct().ToArray(),
                RoleIds = [.. roleIds],
                MenuIds = [.. menuIds],
                IsSuperAdmin = isSuperAdmin
            };
            await permissionCache.SetAsync(key, rs);
            return rs;
        }

        /// <summary>
        /// 删除用户权限缓存（通过角色ID）
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public async Task RemoveUserPermissionCacheByRoleIdAsync(Guid roleId)
        {
            var userRoles = await _userRoleRepository.Where(x => x.RoleId == roleId).ToListAsync();
            foreach (var item in userRoles)
            {
                await RemoveUserPermissionCacheByUserIdAsync(item.UserId);
            }
        }

        /// <summary>
        /// 删除用户权限缓存（通过用户ID）
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task RemoveUserPermissionCacheByUserIdAsync(Guid userId)
        {
            await permissionCache.RemoveAsync(SystemCacheKey.UserPermission(userId));
        }

        /// <summary>
        /// 检查用户是否有权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="code"></param>
        /// <returns></returns>
        public async Task<bool> CheckPermissionAsync(string userId, string code)
        {
            var permission = await GetUserPermissionAsync(Guid.Parse(userId));
            if (permission == null || permission.Auths == null) return false;

            return permission.Auths.Contains(code) || permission.IsSuperAdmin;
        }

        /// <summary>
        /// 生成Token
        /// </summary>
        /// <param name="claims"></param>
        /// <param name="expireTime"></param>
        /// <returns></returns>
        public string GenerateToken(IEnumerable<Claim> claims, DateTime expireTime)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("Jwt")["IssuerSigningKey"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var securityToken = new JwtSecurityToken(
                issuer: _configuration.GetSection("Jwt")["ValidIssuer"],
                audience: _configuration.GetSection("Jwt")["ValidAudience"],
                claims: claims,
                expires: expireTime,
                signingCredentials: creds);

            var token = new JwtSecurityTokenHandler().WriteToken(securityToken);

            return token;
        }

        /// <summary>
        /// 从Token中获取用户身份
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        public ClaimsPrincipal? GetPrincipalFromAccessToken(string token)
        {
            var handler = new JwtSecurityTokenHandler();

            try
            {
                var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("Jwt")["IssuerSigningKey"]!));
                return handler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateAudience = false,
                    ValidateIssuer = false,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = key,
                    ValidateLifetime = false
                }, out SecurityToken validatedToken);
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 用户是否来源主库
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public Task<bool> UserIsFromMainDbAsync(string id)
        {
            // TODO: 需要将当前租户切换到Host
            return _userRepository.Select.AnyAsync(x => x.Id.ToString() == id);
        }
    }
}