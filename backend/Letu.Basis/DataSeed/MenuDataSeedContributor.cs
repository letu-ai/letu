using Letu.Basis.Admin.Menus;
using Letu.Basis.Permissions;
using Letu.Repository;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Guids;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.DataSeed;

public class MenuDataSeedContributor : IDataSeedContributor, ITransientDependency
{
    private readonly ICurrentTenant currentTenant;
    private readonly IFreeSqlRepository<MenuItem> menuRepository;
    private readonly IFreeSqlRepository<MenuItemPermission> menuPermissionRepository;
    private readonly IGuidGenerator guidGenerator;

    public MenuDataSeedContributor(
        IFreeSqlRepository<MenuItem> menuRepository,
        IFreeSqlRepository<MenuItemPermission> menuPermissionRepository,
        ICurrentTenant currentTenant,
        IGuidGenerator guidGenerator)
    {
        this.menuRepository = menuRepository;
        this.menuPermissionRepository = menuPermissionRepository;
        this.currentTenant = currentTenant;
        this.guidGenerator = guidGenerator;
    }

    public virtual async Task SeedAsync(DataSeedContext context)
    {
        using (currentTenant.Change(context?.TenantId))
        {
            var exists = await menuRepository.Select.AnyAsync();
            if (exists)
            {
                return;
            }
            
            await SeedAdminMenuAsync(context?.TenantId);
            await SeedAppMenuAsync(context?.TenantId);
        }
    }

    private async Task SeedAdminMenuAsync(Guid? tenantId)
    {
        var parentMenus = new Dictionary<string, Guid>();

        // 创建父级菜单（文件夹）
        var folderMenus = new List<MenuItem>
        {
            new MenuItem
            {
                Title = "基础数据",
                Icon = "antd:TeamOutlined",
                ApplicationName = "admin",
                MenuType = MenuType.Folder,
                Sort = 1,
                Display = true,
                IsExternal = false,
            },
            new MenuItem
            {
                Title = "系统管理",
                Icon = "antd:SettingOutlined",
                ApplicationName = "admin",
                MenuType = MenuType.Folder,
                Sort = 2,
                Display = true,
                IsExternal = false,
            },
            new MenuItem
            {
                Title = "系统监控",
                Icon = "antd:FundOutlined",
                ApplicationName = "admin",
                MenuType = MenuType.Folder,
                Sort = 3,
                Display = true,
                IsExternal = false,

            }
        };

        await menuRepository.InsertAsync(folderMenus);

        // 保存父级菜单ID映射
        foreach (var folder in folderMenus)
        {
            parentMenus[folder.Title] = folder.Id;
        }

        // 为需要权限配置的菜单预先生成 ID
        var userMenuId = guidGenerator.Create();
        var roleMenuId = guidGenerator.Create();
        var departmentMenuId = guidGenerator.Create();
        var positionGroupMenuId = guidGenerator.Create();
        var positionMenuId = guidGenerator.Create();
        var employeeMenuId = guidGenerator.Create();
        var regionMenuId = guidGenerator.Create();
        var settingsMenuId = guidGenerator.Create();
        var menuManagementMenuId = guidGenerator.Create();
        var dataDictionaryMenuId = guidGenerator.Create();
        var tenantManagementMenuId = guidGenerator.Create();
        var editionMenuId = guidGenerator.Create();
        var notificationMenuId = guidGenerator.Create();
        var scheduledTaskMenuId = guidGenerator.Create();

        // 创建子菜单
        var childMenus = new List<MenuItem>
        {
            // 基础数据下的菜单
            new MenuItem(userMenuId)
            {
                Title = "用户",
                Path = "/admin/users",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 10,
                Display = true,
                IsExternal = false,
            },
            new MenuItem(roleMenuId)
            {
                Title = "角色",
                Path = "/admin/roles",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 20,
                Display = true,
                IsExternal = false,
            },
            new MenuItem(departmentMenuId)
            {
                Title = "部门",
                Path = "/admin/departments",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 30,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(positionGroupMenuId)
            {
                Title = "职位分组",
                Path = "/admin/positions/groups",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 40,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(positionMenuId)
            {
                Title = "职位",
                Path = "/admin/positions",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 41,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(employeeMenuId)
            {
                Title = "员工",
                Path = "/admin/employees",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 50,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(regionMenuId)
            {
                Title = "行政区域",
                Path = "/admin/regions",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["基础数据"],
                Sort = 90,
                Display = true,
                IsExternal = false,

            },
            // 系统管理下的菜单
            new MenuItem(settingsMenuId)
            {
                Title = "设置",
                Path = "/admin/settings",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 10,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(menuManagementMenuId)
            {
                Title = "菜单管理",
                Path = "/admin/menus/admin",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 20,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(dataDictionaryMenuId)
            {
                Title = "数据字典",
                Path = "/admin/data-dictionaries",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 40,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(tenantManagementMenuId)
            {
                Title = "租户管理",
                Path = "/admin/tenants",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 80,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(editionMenuId)
            {
                Title = "版本",
                Path = "/admin/editions",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 81,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(notificationMenuId)
            {
                Title = "系统通知",
                Path = "/admin/notifications",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统管理"],
                Sort = 90,
                Display = true,
                IsExternal = false,

            },
            // 系统监控下的菜单
            new MenuItem(guidGenerator.Create())
            {
                Title = "在线用户",
                Path = "/admin/online-users",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 1,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(guidGenerator.Create())
            {
                Title = "异常日志",
                Path = "/admin/loggings/exception",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 2,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(scheduledTaskMenuId)
            {
                Title = "定时任务",
                Path = "/admin/scheduled-tasks",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 10,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(guidGenerator.Create())
            {
                Title = "登录日志",
                Path = "/admin/loggings/security",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 10,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(guidGenerator.Create())
            {
                Title = "业务日志",
                Path = "/admin/loggings/business",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 11,
                Display = true,
                IsExternal = false,

            },
            new MenuItem(guidGenerator.Create())
            {
                Title = "审计日志",
                Path = "/admin/loggings/auditlog/request",
                ApplicationName = "admin",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["系统监控"],
                Sort = 10,
                Display = true,
                IsExternal = false,

            }
        };

        await menuRepository.InsertAsync(childMenus);

        // 创建菜单权限关联
        var menuPermissions = new List<MenuItemPermission>
        {
            // 基础数据菜单权限
            new MenuItemPermission
            {
                MenuItemId = userMenuId,
                Permission = BasisPermissions.User.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = roleMenuId,
                Permission = BasisPermissions.Role.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = departmentMenuId,
                Permission = BasisPermissions.Department.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = positionMenuId,
                Permission = BasisPermissions.Position.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = employeeMenuId,
                Permission = BasisPermissions.Employee.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = regionMenuId,
                Permission = BasisPermissions.Region.Default,

            },
            
            // 系统管理菜单权限
            new MenuItemPermission
            {
                MenuItemId = settingsMenuId,
                Permission = BasisPermissions.Setting.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = menuManagementMenuId,
                Permission = BasisPermissions.MenuItem.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = dataDictionaryMenuId,
                Permission = BasisPermissions.DataDictionary.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = tenantManagementMenuId,
                Permission = BasisPermissions.Tenant.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = editionMenuId,
                Permission = BasisPermissions.Edition.Default,

            },
            new MenuItemPermission
            {
                MenuItemId = notificationMenuId,
                Permission = BasisPermissions.Notification.Default,

            },
            
            // 系统监控菜单权限
            new MenuItemPermission
            {
                MenuItemId = scheduledTaskMenuId,
                Permission = BasisPermissions.ScheduledTask.Default,

            }
        };

        // 插入菜单权限数据
        await menuPermissionRepository.InsertAsync(menuPermissions);
    }


    private async Task SeedAppMenuAsync(Guid? tenantId)
    {
        var parentMenus = new Dictionary<string, Guid>();

        // 创建 app 应用的父级菜单（文件夹）
        var testFolder = new MenuItem(guidGenerator.Create())
        {
            Title = "Demo",
            ApplicationName = "app",
            MenuType = MenuType.Folder,
            Sort = 1,
            Display = true,
            IsExternal = false,

        };

        await menuRepository.InsertAsync(testFolder);
        parentMenus["Demo"] = testFolder.Id;

        // 创建 test 文件夹下的子菜单
        var childMenus = new List<MenuItem>
        {
            new MenuItem(guidGenerator.Create())
            {
                Title = "行政区域",
                Path = "/home/demo/region",
                ApplicationName = "app",
                MenuType = MenuType.Menu,
                ParentId = parentMenus["Demo"],
                Sort = 0,
                Display = true,
                IsExternal = false,

            }
        };

        await menuRepository.InsertAsync(childMenus);
    }
}
