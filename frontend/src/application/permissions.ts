/**
 * 权限定义 - 与后端 BasisPermissions.cs 保持同步
 * 该文件定义了系统中所有的权限常量
 */

export class BasisPermissions {
    // 基础数据权限组
    public static readonly BaseDataGroupName = "Basis";

    // 用户管理权限
    public static readonly User = {
        /** 用户管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.User`,
        Create: `${BasisPermissions.BaseDataGroupName}.User.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.User.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.User.Delete`,
        ManagePermission: `${BasisPermissions.BaseDataGroupName}.User.ManagePermission`,
        ResetPassword: `${BasisPermissions.BaseDataGroupName}.User.ResetPassword`,
        /** 注销在线用户 */
        Revoke: `${BasisPermissions.BaseDataGroupName}.User.Revoke`,
    } as const;

    // 用户查询权限
    public static readonly UserLookup = {
        /** 用户查询 */
        Default: `${BasisPermissions.BaseDataGroupName}.UserLookup`,
    } as const;

    // 角色管理权限
    public static readonly Role = {
        /** 角色管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.Role`,
        Create: `${BasisPermissions.BaseDataGroupName}.Role.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.Role.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.Role.Delete`,
        /** 管理角色权限 */
        ManagePermission: `${BasisPermissions.BaseDataGroupName}.Role.ManagePermission`,
    } as const;

    // 客户端管理权限
    public static readonly ClientApp = {
        /** 客户端管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.ClientApp`,
        Create: `${BasisPermissions.BaseDataGroupName}.ClientApp.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.ClientApp.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.ClientApp.Delete`,
        /** 管理客户端权限 */
        ManagePermission: `${BasisPermissions.BaseDataGroupName}.ClientApp.ManagePermission`,
    } as const;

    // 部门管理权限
    public static readonly Department = {
        /** 部门管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.Department`,
        Create: `${BasisPermissions.BaseDataGroupName}.Department.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.Department.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.Department.Delete`,
    } as const;

    // 菜单管理权限
    public static readonly MenuItem = {
        /** 菜单管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.MenuItem`,
        Create: `${BasisPermissions.BaseDataGroupName}.MenuItem.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.MenuItem.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.MenuItem.Delete`,
    } as const;

    // 组织机构管理权限
    public static readonly OrganizationUnit = {
        /** 组织机构管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.OrganizationUnit`,
        Create: `${BasisPermissions.BaseDataGroupName}.OrganizationUnit.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.OrganizationUnit.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.OrganizationUnit.Delete`,
    } as const;

    // 员工管理权限
    public static readonly Employee = {
        /** 员工管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.Employee`,
        Create: `${BasisPermissions.BaseDataGroupName}.Employee.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.Employee.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.Employee.Delete`,
        BindUser: `${BasisPermissions.BaseDataGroupName}.Employee.BindUser`,
    } as const;

    // 职位管理权限
    public static readonly Position = {
        /** 职位管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.Position`,
        Create: `${BasisPermissions.BaseDataGroupName}.Position.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.Position.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.Position.Delete`,
    } as const;


    // 数据字典管理权限
    public static readonly DataDictionary = {
        /** 数据字典管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.DataDictionary`,
        Create: `${BasisPermissions.BaseDataGroupName}.DataDictionary.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.DataDictionary.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.DataDictionary.Delete`,
    } as const;

    // 通知管理权限
    public static readonly Notification = {
        /** 通知管理 */
        Default: `${BasisPermissions.BaseDataGroupName}.Notification`,
        Create: `${BasisPermissions.BaseDataGroupName}.Notification.Create`,
        Update: `${BasisPermissions.BaseDataGroupName}.Notification.Update`,
        Delete: `${BasisPermissions.BaseDataGroupName}.Notification.Delete`,
    } as const;

    // 系统设置权限组
    public static readonly SettingGroupName = "Setting";

    // 系统设置权限
    public static readonly Setting = {
        /** 系统设置 */
        Default: `${BasisPermissions.SettingGroupName}.Setting`,
        /** 邮件设置 */
        Emailing: `${BasisPermissions.SettingGroupName}.Setting.Emailling`,
        /** 发送邮件测试 */
        EmailingTest: `${BasisPermissions.SettingGroupName}.Setting.Emailling.Test`,
        /** 时区设置 */
        TimeZone: `${BasisPermissions.SettingGroupName}.Setting.TimeZone`,
    } as const;

    // 功能管理权限
    public static readonly Feature = {
        /** 功能管理 */
        Default: `${BasisPermissions.SettingGroupName}.Feature`,
        /** 管理主机的功能 */
        ManageHostFeatures: `${BasisPermissions.SettingGroupName}.ManageHostFeatures`,
    } as const;

    // 定时任务管理权限
    public static readonly ScheduledTask = {
        /** 定时任务管理 */
        Default: `${BasisPermissions.SettingGroupName}.ScheduledTask`,
        Create: `${BasisPermissions.SettingGroupName}.ScheduledTask.Create`,
        Update: `${BasisPermissions.SettingGroupName}.ScheduledTask.Update`,
        Delete: `${BasisPermissions.SettingGroupName}.ScheduledTask.Delete`,
        Log: `${BasisPermissions.SettingGroupName}.ScheduledTask.Log`,
    } as const;

    // SaaS权限组
    public static readonly SaasGroupName = "Saas";

    // 租户管理权限
    public static readonly Tenant = {
        /** 租户管理 */
        Default: `${BasisPermissions.SaasGroupName}.Tenant`,
        Create: `${BasisPermissions.SaasGroupName}.Tenant.Create`,
        Update: `${BasisPermissions.SaasGroupName}.Tenant.Update`,
        Delete: `${BasisPermissions.SaasGroupName}.Tenant.Delete`,
        /** 管理租户功能 */
        ManageFeatures: `${BasisPermissions.SaasGroupName}.Tenant.ManageFeatures`,
        /** 管理租户连接字符串 */
        ManageConnectionStrings: `${BasisPermissions.SaasGroupName}.Tenant.ManageConnectionStrings`,
    } as const;

    // 版本管理权限
    public static readonly Edition = {
        /** 版本管理 */
        Default: `${BasisPermissions.SaasGroupName}.Edition`,
        Create: `${BasisPermissions.SaasGroupName}.Edition.Create`,
        Update: `${BasisPermissions.SaasGroupName}.Edition.Update`,
        Delete: `${BasisPermissions.SaasGroupName}.Edition.Delete`,
        /** 管理版本的功能 */
        ManageFeatures: `${BasisPermissions.SaasGroupName}.Edition.ManageFeatures`,
    } as const;

    /**
     * 获取所有权限值的数组
     * @returns 所有权限字符串的数组
     */
    public static getAllPermissions(): string[] {
        const permissions: string[] = [];
        
        // 递归获取所有权限值
        const extractPermissions = (obj: any): void => {
            for (const key in obj) {
                if (typeof obj[key] === 'string') {
                    permissions.push(obj[key]);
                } else if (typeof obj[key] === 'object' && obj[key] !== null) {
                    extractPermissions(obj[key]);
                }
            }
        };

        // 提取所有权限
        extractPermissions({
            User: this.User,
            UserLookup: this.UserLookup,
            Role: this.Role,
            ClientApp: this.ClientApp,
            Department: this.Department,
            MenuItem: this.MenuItem,
            OrganizationUnit: this.OrganizationUnit,
            DataDictionary: this.DataDictionary,
            Setting: this.Setting,
            Feature: this.Feature,
            Tenant: this.Tenant,
            Edition: this.Edition,
        });

        return permissions;
    }
}

// 权限类型定义
export type UserPermissions = typeof BasisPermissions.User;
export type UserLookupPermissions = typeof BasisPermissions.UserLookup;
export type RolePermissions = typeof BasisPermissions.Role;
export type ClientAppPermissions = typeof BasisPermissions.ClientApp;
export type DepartmentPermissions = typeof BasisPermissions.Department;
export type MenuItemPermissions = typeof BasisPermissions.MenuItem;
export type OrganizationUnitPermissions = typeof BasisPermissions.OrganizationUnit;
export type DataDictionaryPermissions = typeof BasisPermissions.DataDictionary;
export type SettingPermissions = typeof BasisPermissions.Setting;
export type FeaturePermissions = typeof BasisPermissions.Feature;
export type TenantPermissions = typeof BasisPermissions.Tenant;
export type EditionPermissions = typeof BasisPermissions.Edition;

// 所有权限的联合类型
export type AllPermissionKeys = 
    | keyof UserPermissions
    | keyof UserLookupPermissions
    | keyof RolePermissions
    | keyof ClientAppPermissions
    | keyof DepartmentPermissions
    | keyof MenuItemPermissions
    | keyof OrganizationUnitPermissions
    | keyof DataDictionaryPermissions
    | keyof SettingPermissions
    | keyof FeaturePermissions
    | keyof TenantPermissions
    | keyof EditionPermissions;

// 导出默认对象
export default BasisPermissions;
