namespace Letu.Basis.Settings;

public static class IdentitySettingNames
{
    private const string Prefix = "Letu.Identity";

    public static class Password
    {
        private const string PasswordPrefix = Prefix + ".Password";

        /// <summary>
        /// 要求长度 - 密码的最小长度
        /// </summary>
        public const string RequiredLength = PasswordPrefix + ".RequiredLength";
        /// <summary>
        /// 要求唯一字符数量 - 密码必须包含唯一字符的数量
        /// </summary>
        public const string RequiredUniqueChars = PasswordPrefix + ".RequiredUniqueChars";
        /// <summary>
        /// 要求非字母数字 - 密码是否必须包含非字母数字
        /// </summary>
        public const string RequireNonAlphanumeric = PasswordPrefix + ".RequireNonAlphanumeric";
        /// <summary>
        /// 要求小写字母 - 密码是否必须包含小写字母
        /// </summary>
        public const string RequireLowercase = PasswordPrefix + ".RequireLowercase";
        /// <summary>
        /// 要求大写字母 - 密码是否必须包含大写字母
        /// </summary>
        public const string RequireUppercase = PasswordPrefix + ".RequireUppercase";
        /// <summary>
        /// 要求数字 - 密码是否必须包含数字
        /// </summary>
        public const string RequireDigit = PasswordPrefix + ".RequireDigit";
        /// <summary>
        /// 强制用户定期更改密码 - 是否强制用户定期更改密码
        /// </summary>
        public const string ForceUsersToPeriodicallyChangePassword = PasswordPrefix + ".ForceUsersToPeriodicallyChangePassword";
        /// <summary>
        /// 密码更改周期(天) - 用户必须更改密码的周期(天)
        /// </summary>
        public const string PasswordChangePeriodDays = PasswordPrefix + ".PasswordChangePeriodDays";
    }

    public static class Lockout
    {
        private const string LockoutPrefix = Prefix + ".Lockout";

        /// <summary>
        /// 允许新用户 - 允许新用户被锁定
        /// </summary>
        public const string AllowedForNewUsers = LockoutPrefix + ".AllowedForNewUsers";
        /// <summary>
        /// 锁定时间(秒) - 当锁定发生时用户被的锁定的时间(秒)
        /// </summary>
        public const string LockoutDuration = LockoutPrefix + ".LockoutDuration";
        /// <summary>
        /// 最大失败访问尝试次数 - 如果启用锁定, 当用户被锁定前失败的访问尝试次数
        /// </summary>
        public const string MaxFailedAccessAttempts = LockoutPrefix + ".MaxFailedAccessAttempts";
    }

    public static class SignIn
    {
        private const string SignInPrefix = Prefix + ".SignIn";

        /// <summary>
        /// 登录需要验证邮箱 - 用户可以创建账户但在验证邮箱地址之前无法登录
        /// </summary>
        public const string RequireConfirmedEmail = SignInPrefix + ".RequireConfirmedEmail";
        /// <summary>
        /// 强制要求验证电子邮件才能注册 - 用户帐户将不会被创建，除非他们验证他们的电子邮件地址
        /// </summary>
        public const string RequireEmailVerificationToRegister = SignInPrefix + ".RequireEmailVerificationToRegister";
        /// <summary>
        /// 允许用户验证手机号码 - 用户可以验证他们的手机号码。需要短信集成
        /// </summary>
        public const string EnablePhoneNumberConfirmation = SignInPrefix + ".EnablePhoneNumberConfirmation";
        /// <summary>
        /// 登录需要验证手机号码 - 用户可以创建账户但在验证手机号码之前无法登录
        /// </summary>
        public const string RequireConfirmedPhoneNumber = SignInPrefix + ".RequireConfirmedPhoneNumber";
        /// <summary>
        /// 允许多设备登录 - 允许用户在多个设备上同时登录
        /// </summary>
        public const string AllowMultipleLogin = SignInPrefix + ".AllowMultipleLogin";
    }

    public static class User
    {
        private const string UserPrefix = Prefix + ".User";

        /// <summary>
        /// 启用用户名更新 - 是否允许用户更新用户名
        /// </summary>
        public const string IsUserNameUpdateEnabled = UserPrefix + ".IsUserNameUpdateEnabled";
        /// <summary>
        /// 启用电子邮箱更新 - 用户是否可以更新电子邮件
        /// </summary>
        public const string IsEmailUpdateEnabled = UserPrefix + ".IsEmailUpdateEnabled";
    }

    public static class OrganizationUnit
    {
        private const string OrganizationUnitPrefix = Prefix + ".OrganizationUnit";

        /// <summary>
        /// 最大用户成员数量 - 组织单元中最大用户成员数量
        /// </summary>
        public const string MaxUserMembershipCount = OrganizationUnitPrefix + ".MaxUserMembershipCount";
    }
}
