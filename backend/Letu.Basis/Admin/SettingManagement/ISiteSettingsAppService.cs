using Letu.Basis.Admin.SettingManagement.Dtos;

namespace Letu.Basis.Admin.SettingManagement;

public interface ISiteSettingsAppService
{
    Task<SiteSettingsDto> GetAsync();
    Task UpdateAsync(SiteSettingsDto input);
}

