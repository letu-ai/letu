namespace Letu.Basis.Account.Dtos;

public class SignInSettingsDto
{
    /// <summary>
    /// 当前租户名称
    /// </summary>
    public string? TenantName { get; set; }

    /// <summary>
    /// 系统是否启用多租户
    /// </summary>
    public bool MultiTenancyEnabled { get; set; }

    /// <summary>
    /// 是否启用本地登录
    /// </summary>  
    public bool LocalLoginEnabled { get; set; }

    /// <summary>
    /// 是否启用自注册
    /// </summary>
    public bool IsSelfRegistrationEnabled { get; set; }

    /// <summary>
    /// 是否允许密码找回
    /// </summary>
    public bool AllowPasswordRecovery { get; set; }

    /// <summary>
    /// 登录方式
    /// </summary>
    public Dictionary<string, bool> LoginMethods { get; set; } = [];

    /// <summary>
    /// 注册方式
    /// </summary>
    public Dictionary<string, bool> RegistrationMethods { get; set; } = [];
}
