using Volo.Abp.Reflection;

namespace Letu.Basis.Permissions;

public static class BasisPermissions
{
    // 定义权限常量。

    public const string BaseDataGroupName = "Basis";

    public static class User
    {
        /// <summary>
        /// 用户管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".User";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
        public const string ManagePermission = Default + ".ManagePermission";

        /// <summary>
        /// 重置密码
        /// </summary>
        public const string ResetPassword = Default + ".ResetPassword";

        /// <summary>
        /// 注销登录
        /// </summary>
        public const string Revoke = Default + ".Revoke";
    }

    public static class UserLookup
    {
        /// <summary>
        /// 用户查询
        /// </summary>
        public const string Default = BaseDataGroupName + ".UserLookup";
    }

    public static class Role
    {
        /// <summary>
        /// 角色管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".Role";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";

        /// <summary>
        /// 管理角色权限
        /// </summary>
        public const string ManagePermission = Default + ".ManagePermission";
    }

    public static class ClientApp
    {
        /// <summary>
        /// 客户端管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".ClientApp";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";

        /// <summary>
        /// 管理客户端权限
        /// </summary>
        public const string ManagePermission = Default + ".ManagePermission";
    }

    public static class Department
    {
        /// <summary>
        /// 部门管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".Department";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
    }

    public static class MenuItem
    {
        /// <summary>
        /// 菜单管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".MenuItem";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
    }

    public static class OrganizationUnit
    {
        /// <summary>
        /// 组织机构管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".OrganizationUnit";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
    }

    public static class DataDictionary
    {
        /// <summary>
        /// 数据字典管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".DataDictionary";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
    }

    public static class Employee
    {
        /// <summary>
        /// 员工管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".Employee";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
        public const string BindUser = Default + ".BindUser";
 
    }

    public static class Position
    {
        /// <summary>
        /// 职位管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".Position";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
        public const string BindEmployee = Default + ".BindEmployee";
    }

    public static class Notification
    {
        /// <summary>
        /// 通知管理
        /// </summary>
        public const string Default = BaseDataGroupName + ".Notification";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
    }


    // 系统设置
    public const string SettingGroupName = "Setting";

    public static class Setting
    {
        /// <summary>
        /// 系统设置
        /// </summary>
        public const string Default = SettingGroupName + ".Setting";

        /// <summary>
        /// 邮件设置
        /// </summary>
        public const string Emailing = Default + ".Emailling";

        /// <summary>
        /// 发送邮件测试
        /// </summary>
        public const string EmailingTest = Emailing + ".Test";

        /// <summary>
        /// 时区设置
        /// </summary>
        public const string TimeZone = Default + ".TimeZone";
    }

    public static class Feature
    {
        /// <summary>
        /// 功能管理
        /// </summary>
        public const string Default = SettingGroupName + ".Feature";

        /// <summary>
        /// 管理主机的功能
        /// </summary>
        public const string ManageHostFeatures = SettingGroupName + ".ManageHostFeatures";
    }

    public static class ScheduledTask
    {
        /// <summary>
        /// 定时任务管理
        /// </summary>
        public const string Default = SettingGroupName + ".ScheduledTask";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";
        public const string Log = Default + ".Log";
    }

    // 租户管理
    public const string SaasGroupName = "Saas";

    public static class Tenant
    {
        /// <summary>
        /// 租户管理
        /// </summary>
        public const string Default = SaasGroupName + ".Tenant";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";

        /// <summary>
        /// 管理租户功能
        /// </summary>
        public const string ManageFeatures = Default + ".ManageFeatures";

        /// <summary>
        /// 管理租户连接字符串
        /// </summary>
        public const string ManageConnectionStrings = Default + ".ManageConnectionStrings";
    }

    public static class Edition
    {
        /// <summary>
        /// 版本管理
        /// </summary>
        public const string Default = SaasGroupName + ".Edition";
        public const string Create = Default + ".Create";
        public const string Update = Default + ".Update";
        public const string Delete = Default + ".Delete";

        /// <summary>
        /// 管理版本的功能
        /// </summary>
        public const string ManageFeatures = Default + ".ManageFeatures";

    }



    public static string[] GetAll()
    {
        return ReflectionHelper.GetPublicConstantsRecursively(typeof(BasisPermissions));
    }
}
