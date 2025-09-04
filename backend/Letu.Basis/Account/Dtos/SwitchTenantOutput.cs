namespace Letu.Basis.Account.Dtos;

public class SwitchTenantOutput
{
    public bool Success { get; set; }

    public required string CookieKey { get; set; }

    public Guid? TenantId { get; set; }
}
