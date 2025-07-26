using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

using Letu.Admin.Entities.System;
using Letu.Core.Authorization;
using Letu.Core.Interfaces;
using Letu.Redis;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Enums;
using Letu.Shared.Keys;

using FreeSql;

using Microsoft.IdentityModel.Tokens;

namespace Letu.Admin.SharedService
{
    public class IdentitySharedService : IScopedDependency
    {
        private readonly IRepository<UserRoleDO> _userRoleRepository;
        private readonly IRepository<RoleMenuDO> _roleMenuRepository;
        private readonly IRepository<RoleDO> _roleRepository;
        private readonly IRepository<MenuDO> _menuRepository;
        private readonly IConfiguration _configuration;
        private readonly IRepository<UserDO> _userRepository;
        private readonly IHybridCache _hybridCache;

        public IdentitySharedService(IRepository<UserRoleDO> userRoleRepository, IRepository<RoleMenuDO> roleMenuRepository, IRepository<RoleDO> roleRepository,
            IRepository<MenuDO> menuRepository, IConfiguration configuration, IRepository<UserDO> userRepository, IHybridCache hybridCache)
        {
            _userRoleRepository = userRoleRepository;
            _roleMenuRepository = roleMenuRepository;
            _roleRepository = roleRepository;
            _menuRepository = menuRepository;
            _configuration = configuration;
            _userRepository = userRepository;
            _hybridCache = hybridCache;
        }

        /// <summary>
        /// 获取用户权限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<UserPermission> GetUserPermissionAsync(Guid userId)
        {
            var key = SystemCacheKey.UserPermission(userId);
            if (await _hybridCache.ExistsAsync(key))
            {
                var cacheValue = await _hybridCache.GetAsync<UserPermission>(key);
                return cacheValue!;
            }

            var roleIds = await _userRoleRepository.Where(x => x.UserId == userId).ToListAsync(x => x.RoleId);
            var roles = await _roleRepository.Where(x => roleIds.Contains(x.Id) && x.IsEnabled).ToListAsync();
            var isSuperAdmin = roles.Any(r => r.RoleName == AdminConsts.SuperAdminRole);
            var menuIds = await _roleMenuRepository.Where(x => roleIds.Contains(x.RoleId)).ToListAsync(x => x.MenuId);
            var menus = await _menuRepository.Select.Where(x => menuIds.Contains(x.Id) || isSuperAdmin).ToListAsync(x => new { x.Permission, x.Id, x.MenuType });
            if (isSuperAdmin)
            {
                menuIds = menus.Select(x => x.Id).ToList();
            }
            var rs = new UserPermission
            {
                UserId = userId,
                Roles = roles.Select(c => c.RoleName).ToArray(),
                Auths = menus.Where(c => !string.IsNullOrEmpty(c.Permission) && c.MenuType == MenuType.Button).Select(c => c.Permission!).Distinct().ToArray(),
                RoleIds = [.. roleIds],
                MenuIds = [.. menuIds],
                IsSuperAdmin = isSuperAdmin
            };
            await _hybridCache.SetAsync(key, rs);
            return rs;
        }

        /// <summary>
        /// 删除用户权限缓存（通过角色ID）
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public async Task DelUserPermissionCacheByRoleIdAsync(Guid roleId)
        {
            var userRoles = await _userRoleRepository.Where(x => x.RoleId == roleId).ToListAsync();
            foreach (var item in userRoles)
            {
                await DelUserPermissionCacheByUserIdAsync(item.UserId);
            }
        }

        /// <summary>
        /// 删除用户权限缓存（通过用户ID）
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public Task DelUserPermissionCacheByUserIdAsync(Guid userId)
        {
            return _hybridCache.RemoveAsync(SystemCacheKey.UserPermission(userId));
        }

        /// <summary>
        /// 检查Token是否存在
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="sessionId"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public async Task<bool> CheckTokenAsync(string userId, string sessionId, string token)
        {
            string key = SystemCacheKey.AccessToken(userId, sessionId);
            var existToken = await _hybridCache.GetAsync<string>(key);
            return existToken == token;
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
            TenantManager.SetCurrent("");
            return _userRepository.Select.AnyAsync(x => x.Id.ToString() == id);
        }
    }
}