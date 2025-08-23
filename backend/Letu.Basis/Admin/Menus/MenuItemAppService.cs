using FreeSql;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Core.Utils;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Features;
using Volo.Abp.SimpleStateChecking;

namespace Letu.Basis.Admin.Menus
{
    public class MenuItemAppService : BasisAppService, IMenuItemAppService
    {
        private readonly IFreeSqlRepository<MenuItem> menuRepository;
        private readonly IPermissionDefinitionManager permissionDefinitionManager;
        private readonly IFeatureDefinitionManager featureDefinitionManager;
        private readonly ISimpleStateCheckerManager<MenuItem> simpleStateCheckerManager;

        public MenuItemAppService(
            IFreeSqlRepository<MenuItem> menuRepository,
            ISimpleStateCheckerManager<MenuItem> simpleStateCheckerManager,
            IPermissionDefinitionManager permissionDefinitionManager,
            IFeatureDefinitionManager featureDefinitionManager)
        {
            this.menuRepository = menuRepository;
            this.simpleStateCheckerManager = simpleStateCheckerManager;
            this.permissionDefinitionManager = permissionDefinitionManager;
            this.featureDefinitionManager = featureDefinitionManager;
        }

        public async Task AddMenuAsync(MenuItemCreateOrUpdateInput dto)
        {
            if (dto.MenuType == MenuType.Menu && string.IsNullOrWhiteSpace(dto.Path))
            {
                throw new BusinessException(message: "菜单的路由不能为空");
            }
            if (dto.IsExternal && !StringUtils.IsValidUrlStrict(dto.Path))
            {
                throw new BusinessException(message: "外链地址不合法");
            }

            var isExist = await menuRepository.Select.AnyAsync(x => x.Path != null && dto.Path != null && x.Path.ToLower() == dto.Path.ToLower());
            if (isExist)
            {
                throw new BusinessException(message: $"已存在【{dto.Path}】菜单路由");
            }

            var entity = ObjectMapper.Map<MenuItemCreateOrUpdateInput, MenuItem>(dto);
            await menuRepository.InsertAsync(entity);

            // 设置权限和功能关联
            await SetMenuPermissionsAndFeaturesAsync(entity.Id, dto.Permissions, dto.Features);
        }

        public async Task UpdateMenuAsync(Guid id, MenuItemCreateOrUpdateInput input)
        {
            if (input.MenuType == MenuType.Menu && string.IsNullOrWhiteSpace(input.Path))
            {
                throw new BusinessException(message: "菜单的路由不能为空");
            }
            if (input.IsExternal && !StringUtils.IsValidUrlStrict(input.Path))
            {
                throw new BusinessException(message: "外链地址不合法");
            }

            var isExist = await menuRepository.Select.AnyAsync(x => x.Path != null && input.Path != null && x.Path.ToLower() == input.Path.ToLower());
            var entity = await menuRepository.Where(x => x.Id == id).FirstAsync() ?? throw new BusinessException(message: "数据不存在");
            if (isExist && entity.Path != null && input.Path!.ToLower() != entity.Path.ToLower())
            {
                throw new BusinessException(message: $"已存在【{input.Path}】菜单路由");
            }
            // TODO: 增加菜单层级检查
            if (input.ParentId == entity.Id)
            {
                throw new BusinessException(message: "不能选择自己为父级");
            }

            ObjectMapper.Map(input, entity);
            await menuRepository.UpdateAsync(entity);

            // 清除并重新设置权限和功能关联
            await ClearMenuPermissionsAndFeaturesAsync(id);
            await SetMenuPermissionsAndFeaturesAsync(id, input.Permissions, input.Features);
        }

        public async Task DeleteMenusAsync(Guid[] ids)
        {
            // 批量获取所有要删除的菜单项
            var menuItems = await menuRepository.Where(x => ids.Contains(x.Id)).ToListAsync();
            foreach (var item in menuItems)
            {
                if (item.MenuType == MenuType.Folder && (await IsEmptyFolder(item.Id) != true))
                    continue;

                await DeleteMenuItemAsync(item.Id);
            }
        }

        // 检查是否存在以该ID为父级的子菜单
        private async Task<bool> IsEmptyFolder(Guid id)
        {
            var hasChildren = await menuRepository.Select.AnyAsync(x => x.ParentId == id);
            return !hasChildren;
        }

        private async Task DeleteMenuItemAsync(Guid id)
        {
            // 所有检查通过后，执行删除操作
            await menuRepository.DeleteAsync(x => x.Id == id);

            // 批量删除相关的权限和功能关联
            await menuRepository.Orm.Delete<MenuItemPermission>()
                .Where(x => x.MenuItemId == id)
                .ExecuteAffrowsAsync();

            await menuRepository.Orm.Delete<MenuItemFeature>()
                .Where(x => x.MenuItemId == id)
                .ExecuteAffrowsAsync();
        }

        public async Task<List<NavigationMenuDto>> GetNavigationMenuAsync(string applicationName)
        {
            // 获取该分类下的所有菜单项，按排序字段排序
            var items = await menuRepository.Select
                .Where(x => x.ApplicationName == applicationName && x.Display == true)
                .IncludeMany(x => x.Permissions)
                .IncludeMany(x => x.Features)
                .ToListAsync();

            var processedMenuItem = await CheckAccessableAsync(items);

            return ObjectMapper.Map<List<MenuItem>, List<NavigationMenuDto>>(processedMenuItem);
        }


        /// <summary>
        /// 移除不可访问的处理菜单项并更新显示名称。
        /// </summary>
        /// <param name="menuItems"></param>
        /// <returns></returns>
        private async Task<List<MenuItem>> CheckAccessableAsync(List<MenuItem> menuItems)
        {
            var tobeRemoved = new List<MenuItem>();

            // 这句using 是提前异步代码的Context信息，没有的话await代码中读取RequirePermissionsSimpleBatchStateChecker<T>.Current会为null。
            using (var scope = LazyServiceProvider.CreateScope())
            using (RequirePermissionsSimpleBatchStateChecker<MenuItem>.Use(new RequirePermissionsSimpleBatchStateChecker<MenuItem>()))
            {
                foreach (var item in menuItems)
                {
                    if (await CheckPermissionsAsync(item) == false || await CheckFeaturesAsync(item) == false)
                        tobeRemoved.Add(item);
                }
            }

            var processedMenuItem = menuItems
                .Except(tobeRemoved)
                .ToList();

            // 移除不能访问的子节点
            return processedMenuItem
               .Where(x => x.ParentId == null || x.ParentId != null && processedMenuItem.Any(p => p.Id == x.ParentId))
               .ToList();
        }

        private async Task<bool> CheckPermissionsAsync(MenuItem menuItem)
        {
            //未设置权限和特性依赖。
            if (menuItem.Permissions.IsNullOrEmpty())
            {
                return true;
            }

            if (menuItem.Permissions != null && !menuItem.Permissions.IsNullOrEmpty())
                menuItem.RequirePermissions(menuItem.Permissions.Select(x => x.Permission).ToArray());

            return await simpleStateCheckerManager.IsEnabledAsync(menuItem);
        }

        private async Task<bool> CheckFeaturesAsync(MenuItem menuItem)
        {
            //未设置特性依赖。
            if (menuItem.Features.IsNullOrEmpty())
            {
                return true;
            }

            if (menuItem.Features != null && !menuItem.Features.IsNullOrEmpty())
                menuItem.RequireFeatures(menuItem.Features.Select(x => x.Feature).ToArray());

            return await simpleStateCheckerManager.IsEnabledAsync(menuItem);
        }

        public async Task<List<MenuItemListOutput>> GetMenuListAsync(MenuItemListInput dto)
        {
            //是否过滤
            var isFilter = !string.IsNullOrEmpty(dto.Title) || !string.IsNullOrEmpty(dto.Path);
            var all = await menuRepository.Select
                .Where(x => x.ApplicationName == dto.ApplicationName)
                .IncludeMany(x => x.Permissions)
                .IncludeMany(x => x.Features)
                .WhereIf(!string.IsNullOrEmpty(dto.Title), x => !string.IsNullOrEmpty(x.Title) && x.Title.Contains(dto.Title!))
                .WhereIf(!string.IsNullOrEmpty(dto.Path), x => !string.IsNullOrEmpty(x.Path) && x.Path.Contains(dto.Path!))
                .ToListAsync();
            var top = all.Where(x => isFilter || !x.ParentId.HasValue || x.ParentId == Guid.Empty).OrderBy(x => x.Sort).ToList();
            var topMap = ObjectMapper.Map<List<MenuItem>, List<MenuItemListOutput>>(top);

            // 填充权限显示名称
            await FillPermissionDisplayNamesAsync(topMap);
            // 填充功能开关显示名称
            await FillFeatureDisplayNamesAsync(topMap);

            if (isFilter) return topMap;
            foreach (var item in topMap)
            {
                item.Children = getChildren(item.Id);
            }

            List<MenuItemListOutput>? getChildren(Guid currentId)
            {
                var children = all.Where(x => x.ParentId == currentId).OrderBy(x => x.Sort).ToList();
                if (children.Count == 0) return null;
                var childrenMap = ObjectMapper.Map<List<MenuItem>, List<MenuItemListOutput>>(children);

                // 填充子菜单的权限显示名称
                FillPermissionDisplayNamesAsync(childrenMap).Wait();
                // 填充子菜单的功能开关显示名称
                FillFeatureDisplayNamesAsync(childrenMap).Wait();

                foreach (var item in childrenMap)
                {
                    item.Children = getChildren(item.Id);
                }
                return childrenMap;
            }

            return topMap;
        }

        public async Task<List<MenuTreeSelectOption>> GetMenuOptionsAsync(bool onlyFolder, string applicationName)
        {
            // 使用FreeSql的树形查询，按Sort值排序
            var menus = await menuRepository.Select
                .Where(x => x.ApplicationName == applicationName)
                .WhereIf(onlyFolder, x => x.MenuType == MenuType.Folder)
                .ToListAsync(x => new MenuTreeSelectOption
                {
                    Key = x.Id.ToString(),
                    Value = x.Id.ToString(),
                    Title = x.Title,
                    MenuType = x.MenuType,
                    Sort = x.Sort,
                    Parent = x.ParentId.HasValue ? x.ParentId.ToString() : null,
                });

            return BuildMenuTree(menus);
        }

        /// <summary>
        /// 将菜单列表转换成树形结构
        /// </summary>
        /// <param name="menus">菜单列表</param>
        /// <returns>树形菜单列表</returns>
        private List<MenuTreeSelectOption> BuildMenuTree(List<MenuTreeSelectOption> menus)
        {
            // 获取顶级菜单（没有父级或父级为空的菜单）
            var topMenus = menus.Where(x => x.Parent == null)
                               .OrderBy(x => x.Sort)
                               .ToList();

            // 为每个顶级菜单构建子菜单树
            foreach (var menu in topMenus)
            {
                menu.Children = BuildChildrenTree(menu.Value, menus);
            }

            return topMenus;
        }

        /// <summary>
        /// 递归构建子菜单树
        /// </summary>
        /// <param name="parent">父菜单ID</param>
        /// <param name="allMenus">所有菜单列表</param>
        /// <returns>子菜单列表</returns>
        private List<MenuTreeSelectOption>? BuildChildrenTree(string parent, List<MenuTreeSelectOption> allMenus)
        {
            var children = allMenus.Where(x => x.Parent == parent)
                                  .OrderBy(x => x.Sort)
                                  .ToList();

            if (children.Count == 0) return null;

            // 递归构建每个子菜单的子菜单
            foreach (var child in children)
            {
                child.Children = BuildChildrenTree(child.Value, allMenus);
            }

            return children;
        }

        /// <summary>
        /// 填充权限显示名称
        /// </summary>
        /// <param name="menus">菜单列表</param>
        private async Task FillPermissionDisplayNamesAsync(List<MenuItemListOutput> menus)
        {
            if (menus == null || menus.Count == 0) return;

            // 收集所有权限名称
            var allPermissions = new HashSet<string>();
            foreach (var menu in menus)
            {
                if (menu.Permissions != null)
                {
                    foreach (var permission in menu.Permissions)
                    {
                        allPermissions.Add(permission);
                    }
                }
            }

            if (allPermissions.Count == 0) return;

            // 构建权限名称映射字典
            var permissionMap = new Dictionary<string, string>();
            foreach (var permissionName in allPermissions)
            {
                var displayName = await GetPermissionDisplayNameAsync(permissionName);
                permissionMap[permissionName] = displayName;
            }

            // 填充每个菜单的权限显示名称
            foreach (var menu in menus)
            {
                if (menu.Permissions != null && menu.Permissions.Length > 0)
                {
                    menu.PermissionDisplayNames = menu.Permissions
                        .Select(p => permissionMap.GetValueOrDefault(p, p))
                        .ToArray();
                }
            }
        }

        /// <summary>
        /// 填充功能开关显示名称
        /// </summary>
        /// <param name="menus">菜单列表</param>
        private async Task FillFeatureDisplayNamesAsync(List<MenuItemListOutput> menus)
        {
            if (menus == null || menus.Count == 0) return;

            // 收集所有功能开关名称
            var allFeatures = new HashSet<string>();
            foreach (var menu in menus)
            {
                if (menu.Features != null)
                {
                    foreach (var feature in menu.Features)
                    {
                        allFeatures.Add(feature);
                    }
                }
            }

            if (allFeatures.Count == 0) return;

            // 构建功能开关名称映射字典
            var featureMap = new Dictionary<string, string>();
            foreach (var featureName in allFeatures)
            {
                var displayName = await GetFeatureDisplayNameAsync(featureName);
                featureMap[featureName] = displayName;
            }

            // 填充每个菜单的功能开关显示名称
            foreach (var menu in menus)
            {
                if (menu.Features != null && menu.Features.Length > 0)
                {
                    menu.FeatureDisplayNames = menu.Features
                        .Select(f => featureMap.GetValueOrDefault(f, f))
                        .ToArray();
                }
            }
        }

        /// <summary>
        /// 获取功能开关的显示名称
        /// </summary>
        /// <param name="featureName">功能开关名称</param>
        /// <returns>功能开关的显示名称</returns>
        private async Task<string> GetFeatureDisplayNameAsync(string featureName)
        {
            var featureDefinition = await featureDefinitionManager.GetOrNullAsync(featureName);
            if (featureDefinition == null)
            {
                return featureName;
            }

            return featureDefinition.DisplayName?.Localize(StringLocalizerFactory) ?? featureName;
        }

        /// <summary>
        /// 获取权限的显示名称（权限组/权限名）
        /// </summary>
        /// <param name="permissionName">权限名称</param>
        /// <returns>权限的显示名称</returns>
        private async Task<string> GetPermissionDisplayNameAsync(string permissionName)
        {
            var permissionDefinition = await permissionDefinitionManager.GetOrNullAsync(permissionName);
            if (permissionDefinition == null)
            {
                return permissionName;
            }

            // 递归构建完整路径
            var pathParts = new List<string>();
            BuildPermissionPath(permissionDefinition, pathParts);

            return string.Join("/", pathParts);
        }

        /// <summary>
        /// 递归构建权限路径
        /// </summary>
        /// <param name="permission">权限定义</param>
        /// <param name="pathParts">路径部分列表</param>
        private void BuildPermissionPath(PermissionDefinition permission, List<string> pathParts)
        {
            var displayName = permission.DisplayName?.Localize(StringLocalizerFactory) ?? permission.Name;
            pathParts.Insert(0, displayName);

            if (permission.Parent != null)
            {
                BuildPermissionPath(permission.Parent, pathParts);
            }
        }

        /// <summary>
        /// 设置菜单的权限和功能关联
        /// </summary>
        /// <param name="menuId">菜单ID</param>
        /// <param name="permissions">权限数组</param>
        /// <param name="features">功能数组</param>
        private async Task SetMenuPermissionsAndFeaturesAsync(Guid menuId, string[]? permissions, string[]? features)
        {
            // 处理权限关联
            if (permissions != null && permissions.Length > 0)
            {
                var permissionEntities = permissions.Select(p => new MenuItemPermission
                {
                    MenuItemId = menuId,
                    Permission = p,
                    TenantId = CurrentTenant.Id
                }).ToList();
                await menuRepository.Orm.Insert(permissionEntities).ExecuteAffrowsAsync();
            }

            // 处理功能关联
            if (features != null && features.Length > 0)
            {
                var featureEntities = features.Select(f => new MenuItemFeature
                {
                    MenuItemId = menuId,
                    Feature = f,
                    TenantId = CurrentTenant.Id
                }).ToList();
                await menuRepository.Orm.Insert(featureEntities).ExecuteAffrowsAsync();
            }
        }

        /// <summary>
        /// 清除菜单的权限和功能关联
        /// </summary>
        /// <param name="menuId">菜单ID</param>
        private async Task ClearMenuPermissionsAndFeaturesAsync(Guid menuId)
        {
            // 删除现有的权限关联
            await menuRepository.Orm.Delete<MenuItemPermission>()
                .Where(x => x.MenuItemId == menuId)
                .ExecuteAffrowsAsync();

            // 删除现有的功能关联
            await menuRepository.Orm.Delete<MenuItemFeature>()
                .Where(x => x.MenuItemId == menuId)
                .ExecuteAffrowsAsync();
        }
    }
}