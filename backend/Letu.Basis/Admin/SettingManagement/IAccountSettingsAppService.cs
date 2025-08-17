using Letu.Basis.Admin.SettingManagement.Dtos;

namespace Letu.Basis.Admin.SettingManagement;

public interface IAccountSettingsAppService
{
    Task<AccountSettingsDto> GetAsync();
    Task UpdateAsync(AccountSettingsDto input);
}