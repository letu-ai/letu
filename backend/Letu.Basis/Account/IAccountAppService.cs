using Letu.Basis.Account.Dtos;

namespace Letu.Basis.Account;

public interface IAccountAppService
{

    Task<LoginSettingsOutput> GetLoginSettingsAsync();

    Task<SwitchTenantOutput> SwitchTenantAsync(string? tenantName);
}
