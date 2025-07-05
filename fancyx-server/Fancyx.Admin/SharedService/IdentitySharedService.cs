using Fancyx.Admin.Entities.Organization;
using Fancyx.Admin.Entities.System;
using Fancyx.Core.Authorization;
using Fancyx.Shared.Consts;
using Fancyx.Core.Interfaces;
using FreeRedis;

using FreeSql;
using Microsoft.IdentityModel.Tokens;

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Fancyx.Shared.Keys;
using Microsoft.Extensions.Caching.Memory;
using Fancyx.Repository;

namespace Fancyx.Admin.SharedService
{
    public class IdentitySharedService : IScopedDependency
    {
        private readonly IRepository<UserRoleDO> _userRoleRepository;
        private readonly IRepository<RoleMenuDO> _roleMenuRepository;
        private readonly IRepository<RoleDO> _roleRepository;
        private readonly IRepository<MenuDO> _menuRepository;
        private readonly IRedisClient _redisDb;
        private readonly IConfiguration _configuration;
        private readonly ICurrentUser _currentUser;
        private readonly IRepository<RoleDeptDO> _roleDeptRepository;
        private readonly IRepository<DeptDO> _deptRepository;
        private readonly IRepository<EmployeeDO> _employeeRepository;
        private readonly IRepository<UserDO> _userRepository;
        private readonly IMemoryCache _memoryCache;

        public IdentitySharedService(IRepository<UserRoleDO> userRoleRepository, IRepository<RoleMenuDO> roleMenuRepository, IRepository<RoleDO> roleRepository,
            IRepository<MenuDO> menuRepository, IRedisClient redisDb, IConfiguration configuration, ICurrentUser currentUser,
            IRepository<RoleDeptDO> roleDeptRepository, IRepository<DeptDO> deptRepository, IRepository<EmployeeDO> employeeRepository,
            IRepository<UserDO> userRepository, IMemoryCache memoryCache)
        {
            _userRoleRepository = userRoleRepository;
            _roleMenuRepository = roleMenuRepository;
            _roleRepository = roleRepository;
            _menuRepository = menuRepository;
            _redisDb = redisDb;
            _configuration = configuration;
            _currentUser = currentUser;
            _roleDeptRepository = roleDeptRepository;
            _deptRepository = deptRepository;
            _employeeRepository = employeeRepository;
            _userRepository = userRepository;
            _memoryCache = memoryCache;
        }

        /// <summary>
        /// 获取用户权限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<UserPermission> GetUserPermissionAsync(Guid userId)
        {
            var key = SystemCacheKey.UserPermission(userId);
            if (_memoryCache.TryGetValue(key, out UserPermission? value) && value != null) return value;
            if (await _redisDb.ExistsAsync(key))
            {
                var cacheValue = (await _redisDb.GetAsync<UserPermission>(key))!;
                _memoryCache.Set(key, cacheValue);
                return cacheValue;
            }

            var roleIds = await _userRoleRepository.Where(x => x.UserId == userId).ToListAsync(x => x.RoleId);
            var roles = await _roleRepository.Where(x => roleIds.Contains(x.Id) && x.IsEnabled).ToListAsync();
            var isSuperAdmin = roles.Any(r => r.RoleName == AdminConsts.SuperAdminRole);
            var menuIds = await _roleMenuRepository.Where(x => roleIds.Contains(x.RoleId)).ToListAsync(x => x.MenuId);
            var menus = await _menuRepository.Select.Where(x => menuIds.Contains(x.Id) || isSuperAdmin).ToListAsync(x => new { x.Permission, x.Id });
            if (isSuperAdmin)
            {
                menuIds = menus.Select(x => x.Id).ToList();
            }
            var rs = new UserPermission
            {
                UserId = userId,
                Roles = roles.Select(c => c.RoleName).ToArray(),
                Auths = menus.Where(c => !string.IsNullOrEmpty(c.Permission)).Select(c => c.Permission!).Distinct().ToArray(),
                RoleIds = [.. roleIds],
                MenuIds = [.. menuIds],
                IsSuperAdmin = isSuperAdmin
            };
            _memoryCache.Set(key, rs);
            await _redisDb.SetAsync(key, rs);
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
                _memoryCache.Remove(SystemCacheKey.UserPermission(item.UserId));
                await _redisDb.DelAsync(SystemCacheKey.UserPermission(item.UserId));
            }
        }

        /// <summary>
        /// 删除用户权限缓存（通过用户ID）
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task DelUserPermissionCacheByUserIdAsync(Guid userId)
        {
            _memoryCache.Remove(SystemCacheKey.UserPermission(userId));
            await _redisDb.DelAsync(SystemCacheKey.UserPermission(userId));
        }

        /// <summary>
        /// 删除超级管理员用户权限缓存
        /// </summary>
        /// <returns></returns>
        public async Task DelAdminUserPermissionCacheAsync()
        {
            var adminRoleId = (await _roleRepository.Where(x => x.RoleName.ToLower() == AdminConsts.SuperAdminRole).ToListAsync(x => x.Id)).FirstOrDefault();
            if (adminRoleId == Guid.Empty) return;
            await DelUserPermissionCacheByRoleIdAsync(adminRoleId);
        }

        /// <summary>
        /// 删除用户权限缓存（通过菜单ID，通过RoleMenu关系删除）
        /// </summary>
        /// <param name="menuId"></param>
        /// <returns></returns>
        public async Task DelUserPermissionCacheByMenuIdAsync(Guid menuId)
        {
            var roleIds = await _roleMenuRepository.Where(x => x.MenuId == menuId).ToListAsync(x => x.RoleId);
            var adminRoleId = (await _roleRepository.Where(x => x.RoleName.ToLower() == AdminConsts.SuperAdminRole).ToListAsync(x => x.Id)).FirstOrDefault();
            if (adminRoleId != Guid.Empty)
            {
                roleIds.Add(adminRoleId);
            }
            foreach (var item in roleIds)
            {
                await DelUserPermissionCacheByRoleIdAsync(item);
            }
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
            if (_memoryCache.TryGetValue(key, out string? cacheToken) && cacheToken == token)
            {
                return true;
            }
            var existToken = await _redisDb.GetAsync<string>(key);
            if (token == existToken)
            {
                int minute = (int)Math.Floor(_redisDb.Ttl(key) / 60.0);
                if (minute > 20)
                {
                    _memoryCache.Set(key, token, TimeSpan.FromMinutes(minute - 1));
                }

                return true;
            }

            return false;
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

        /// <summary>
        /// 获取当前用户可查看的相关部门，员工
        /// </summary>
        /// <returns></returns>
        public async Task<PowerDataId> GetPowerData()
        {
            var data = new PowerDataId() { DeptIds = [], EmployeeIds = [] };
            var uid = _currentUser.Id!.Value;
            var permission = await GetUserPermissionAsync(uid);
            if (permission.RoleIds == null || permission.RoleIds.Length == 0) return data;

            var roles = await _roleRepository.Select.Where(x => permission.RoleIds != null && permission.RoleIds.Contains(x.Id)).ToListAsync();
            var employee = await _employeeRepository.Where(x => x.UserId == uid && x.DeptId.HasValue).FirstAsync();
            foreach (var role in roles)
            {
                if (role.PowerDataType == 0)
                {
                    data.DeptIds.AddRange([.. await _deptRepository.Select.ToListAsync(x => x.Id)]);
                }
                else if (role.PowerDataType == 1)
                {
                    data.DeptIds.AddRange([.. await _roleDeptRepository.Where(x => x.RoleId == role.Id).ToListAsync(x => x.DeptId)]);
                }
                else if (role.PowerDataType == 2)
                {
                    if (employee != null)
                    {
                        data.DeptIds.AddRange([.. await _deptRepository.Where(x => x.Id == employee.DeptId || x.ParentIds != null && x.ParentIds!.Contains(employee.DeptId.ToString())).ToListAsync(x => x.Id)]);
                    }
                }
                else if (role.PowerDataType == 3)
                {
                    if (employee != null)
                    {
                        data.DeptIds.Add(employee.DeptId!.Value);
                    }
                }
                else if (role.PowerDataType == 4)
                {
                    if (employee != null)
                    {
                        data.DeptIds.Add(employee.DeptId!.Value);
                        data.EmployeeIds.Add(employee.Id);
                    }
                }

                if (role.PowerDataType != 4)
                {
                    data.EmployeeIds.AddRange([.. await _employeeRepository.Where(x => data.DeptIds != null && data.DeptIds.Contains(x.DeptId!.Value)).ToListAsync(x => x.Id)]);
                }
            }

            return data;
        }
    }
}