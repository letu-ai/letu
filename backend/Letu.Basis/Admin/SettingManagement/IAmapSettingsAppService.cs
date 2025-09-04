using Letu.Basis.Admin.SettingManagement.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.SettingManagement;

public interface IAmapSettingsAppService : IApplicationService
{
    Task<AmapSettingsDto> GetAsync();

    Task UpdateAsync(AmapSettingsDto input);
}
