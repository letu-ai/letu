using Letu.Basis.Localization;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Localization;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Permissions;

public class BasisPermissionDefinitionProvider : PermissionDefinitionProvider
{
    public override void Define(IPermissionDefinitionContext context)
    {
        // 基础数据
        var baisiGroup = context.AddGroup(BasisPermissions.BaseDataGroupName, L("Permission:Admin.BaseData"));
        DefineRoles(baisiGroup);
        DefineUsers(baisiGroup);
        DefineClients(baisiGroup);
        DefineMenuItems(baisiGroup);
        DefineOrganizations(baisiGroup);
        DefineDepartments(baisiGroup);
        DefineDataDictionaries(baisiGroup);
        DefineEmployees(baisiGroup);
        DefinePositions(baisiGroup);
        DefineNotifications(baisiGroup);

        // 系统设置
        var settingGroup = context.AddGroup(BasisPermissions.SettingGroupName, L("Permission:Admin.Setting"));
        DefineSettingManagement(settingGroup);
        DefineFeatureManagement(settingGroup);
        DefineScheduledTasks(settingGroup);

        // 租户管理
        var saasGroup = context.AddGroup(BasisPermissions.SaasGroupName, L("Permission:Admin.Saas"));
        DefineTenants(saasGroup);
        DefineEditions(saasGroup);
    }

    // 用户   
    public void DefineUsers(PermissionGroupDefinition group)
    {
        var usersPermission = group.AddPermission(BasisPermissions.User.Default, L("Permission:UserManagement"));
        usersPermission.AddChild(BasisPermissions.User.Create, L("Permission:Create"));
        usersPermission.AddChild(BasisPermissions.User.Update, L("Permission:Edit"));
        usersPermission.AddChild(BasisPermissions.User.Delete, L("Permission:Delete"));
        usersPermission.AddChild(BasisPermissions.User.ManagePermission, L("Permission:ChangePermissions"));
        usersPermission.AddChild(BasisPermissions.User.Revoke, L("Permission:Revoke"));
        usersPermission.AddChild(BasisPermissions.User.ResetPassword, L("Permission:ResetPassword"));

        group.AddPermission(BasisPermissions.UserLookup.Default, L("Permission:UserLookup"))
            .WithProviders(ClientPermissionValueProvider.ProviderName);
    }


    // 角色
    public void DefineRoles(PermissionGroupDefinition group)
    {
        var rolesPermission = group.AddPermission(BasisPermissions.Role.Default, L("Permission:RoleManagement"));
        rolesPermission.AddChild(BasisPermissions.Role.Create, L("Permission:Create"));
        rolesPermission.AddChild(BasisPermissions.Role.Update, L("Permission:Edit"));
        rolesPermission.AddChild(BasisPermissions.Role.Delete, L("Permission:Delete"));
        rolesPermission.AddChild(BasisPermissions.Role.ManagePermission, L("Permission:ChangePermissions"));
    }


    // 客户端应用
    public void DefineClients(PermissionGroupDefinition group)
    {
        var clientsPermission = group.AddPermission(BasisPermissions.ClientApp.Default, L("Permission:ClientManagement"));
        clientsPermission.AddChild(BasisPermissions.ClientApp.Create, L("Permission:Create"));
        clientsPermission.AddChild(BasisPermissions.ClientApp.Update, L("Permission:Edit"));
        clientsPermission.AddChild(BasisPermissions.ClientApp.Delete, L("Permission:Delete"));
        clientsPermission.AddChild(BasisPermissions.ClientApp.ManagePermission, L("Permission:ChangePermissions"));
    }


    // 菜单
    public void DefineMenuItems(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.MenuItem.Default, L("Permission:MenuItemManagement"), MultiTenancySides.Host);
        permission.AddChild(BasisPermissions.MenuItem.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.MenuItem.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.MenuItem.Delete, L("Permission:Delete"));
    }

    // 组织机构
    public void DefineOrganizations(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.OrganizationUnit.Default, L("Permission:OrganizationManagement"));
        permission.AddChild(BasisPermissions.OrganizationUnit.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.OrganizationUnit.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.OrganizationUnit.Delete, L("Permission:Delete"));
    }

    // 部门
    public void DefineDepartments(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Department.Default, L("Permission:DepartmentManagement"));
        permission.AddChild(BasisPermissions.Department.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Department.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Department.Delete, L("Permission:Delete"));
    }

    // 员工
    public void DefineEmployees(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Employee.Default, L("Permission:EmployeeManagement"));
        permission.AddChild(BasisPermissions.Employee.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Employee.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Employee.Delete, L("Permission:Delete"));
        permission.AddChild(BasisPermissions.Employee.BindUser, L("Permission:BindUser"));
    }

    // 职位
    public void DefinePositions(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Position.Default, L("Permission:PositionManagement"));
        permission.AddChild(BasisPermissions.Position.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Position.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Position.Delete, L("Permission:Delete"));
        permission.AddChild(BasisPermissions.Position.BindEmployee, L("Permission:BindEmployee"));
    }

    // 数据字典
    public void DefineDataDictionaries(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.DataDictionary.Default, L("Permission:DataDictionaryManagement"), MultiTenancySides.Host);
        permission.AddChild(BasisPermissions.DataDictionary.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.DataDictionary.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.DataDictionary.Delete, L("Permission:Delete"));
    }

    // 通知
    public void DefineNotifications(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Notification.Default, L("Permission:NotificationManagement"));
        permission.AddChild(BasisPermissions.Notification.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Notification.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Notification.Delete, L("Permission:Delete"));
    }

    // 定时任务
    public void DefineScheduledTasks(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.ScheduledTask.Default, L("Permission:ScheduledTaskManagement"), MultiTenancySides.Host);
        permission.AddChild(BasisPermissions.ScheduledTask.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.ScheduledTask.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.ScheduledTask.Delete, L("Permission:Delete"));
        permission.AddChild(BasisPermissions.ScheduledTask.Log, L("Permission:Log"));
    }

    // 参数管理
    public void DefineSettingManagement(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Setting.Default, L("Permission:SettingManagement"));
        permission.AddChild(BasisPermissions.Setting.Emailing, L("Permission:Emailling"));
        permission.AddChild(BasisPermissions.Setting.EmailingTest, L("Permission:EmailingTest"));
        permission.AddChild(BasisPermissions.Setting.TimeZone, L("Permission:TimeZone"));
    }

    // 功能管理
    public void DefineFeatureManagement(PermissionGroupDefinition group)
    {
        group.AddPermission(BasisPermissions.Feature.Default, L("Permission:FeatureManagement"), multiTenancySide: MultiTenancySides.Host);
        group.AddPermission(BasisPermissions.Feature.ManageHostFeatures,
            L("Permission:ManageHostFeatures"),
            multiTenancySide: MultiTenancySides.Host);
    }

    // 租户管理
    public void DefineTenants(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Tenant.Default, L("Permission:TenantManagement"), multiTenancySide: MultiTenancySides.Host);
        permission.AddChild(BasisPermissions.Tenant.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Tenant.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Tenant.Delete, L("Permission:Delete"));
        permission.AddChild(BasisPermissions.Tenant.ManageFeatures, L("Permission:ManageFeatures"));
        permission.AddChild(BasisPermissions.Tenant.ManageConnectionStrings, L("Permission:ManageConnectionStrings"));
    }

    // 版本管理
    public void DefineEditions(PermissionGroupDefinition group)
    {
        var permission = group.AddPermission(BasisPermissions.Edition.Default, L("Permission:EditionManagement"), multiTenancySide: MultiTenancySides.Host);
        permission.AddChild(BasisPermissions.Edition.Create, L("Permission:Create"));
        permission.AddChild(BasisPermissions.Edition.Update, L("Permission:Edit"));
        permission.AddChild(BasisPermissions.Edition.Delete, L("Permission:Delete"));
        permission.AddChild(BasisPermissions.Edition.ManageFeatures, L("Permission:ManageFeatures"));
    }

    private static LocalizableString L(string name)
    {
        return LocalizableString.Create<BasisResource>(name);
    }
}
