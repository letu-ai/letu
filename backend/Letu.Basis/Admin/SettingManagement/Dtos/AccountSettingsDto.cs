using System.ComponentModel.DataAnnotations;
namespace Letu.Basis.Admin.SettingManagement.Dtos;

public class AccountSettingsDto
{
    // Account * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    public bool IsSelfRegistrationEnabled { get; set; }

    public bool EnableLocalLogin { get; set; }

    public bool AllowPasswordRecovery { get; set; }

    // Password * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    /// <summary>
    /// 要求密码最小长度
    /// </summary>
    [Range(3, 64)]
    public int PasswordRequiredLength { get; set; }


    /// <summary>
    /// 要求密码中的唯一字符数
    /// </summary>
    [Range(0, 26)]
    public int PasswordRequiredUniqueChars { get; set; }

    /// <summary>
    /// 要求非字母数字
    /// </summary>
    public bool PasswordRequireNonAlphanumeric { get; set; }

    /// <summary>
    /// 要求小写字母
    /// </summary>
    public bool PasswordRequireLowercase { get; set; }

    /// <summary>
    /// 要求大写字母
    /// </summary>
    public bool PasswordRequireUppercase { get; set; }

    /// <summary>
    /// 要求数字
    /// </summary>
    public bool PasswordRequireDigit { get; set; }

    /// <summary>
    /// 强制用户定期更改密码
    /// </summary>
    public bool ForceUsersToPeriodicallyChangePassword { get; set; }

    /// <summary>
    /// 密码更改周期天数
    /// </summary>
    public int PasswordChangePeriodDays { get; set; }

    // Lockout * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    /// <summary>
    /// 允许新用户被锁定。
    /// 如果为false，新注册的用户不会自动开启登录失败次数过多自动锁定。
    /// </summary>
    public bool AllowedForNewUsers { get; set; }

    /// <summary>
    /// 锁定时间(秒)
    /// </summary>
    public int LockoutDuration { get; set; }

    /// <summary>
    /// 最大失败访问尝试次数
    /// </summary>
    [Range(1, 999)]
    public int MaxFailedAccessAttempts { get; set; }

    // SignIn * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    /// <summary>
    /// 要求验证的电子邮箱
    /// </summary>
    public bool SignInRequireConfirmedEmail { get; set; }

    /// <summary>
    /// 允许用户确认他们的电话号码
    /// </summary>
    public bool SignInEnablePhoneNumberConfirmation { get; set; }

    /// <summary>
    /// 要求验证的手机号码
    /// </summary>
    public bool SignInRequireConfirmedPhoneNumber { get; set; }

    /// <summary>
    /// 允许多个会话
    /// </summary>
    public bool SignInAllowMultipleLogin { get; set; }

    // User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    /// <summary>
    /// 允许用户更新用户名
    /// </summary>
    public bool IsUserNameUpdateEnabled { get; set; }

    /// <summary>
    /// 允许用户更新电子邮箱
    /// </summary>
    public bool IsEmailUpdateEnabled { get; set; }
}
