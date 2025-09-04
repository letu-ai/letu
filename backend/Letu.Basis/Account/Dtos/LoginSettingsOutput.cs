namespace Letu.Basis.Account.Dtos;

public class LoginSettingsOutput
{
    public string? TenantName { get; set; }

    public bool MultiTenancyEnabled { get; set; }

    public bool EnableUserNameLogin { get; set; }

    public bool EnableEmailLogin { get; set; }

    public bool EnablePhoneNumberLogin { get; set; }

    public bool EnableUserNameRegistration { get; set; }

    public bool EnableEmailRegistration { get; set; }

    public bool EnablePhoneNumberRegistration { get; set; }

    public bool IsSelfRegistrationEnabled { get; set; }

    public bool AllowPasswordRecovery { get; set; }

    public List<ExternalProviderOutput>? ExternalProviders { get; set; }
}
