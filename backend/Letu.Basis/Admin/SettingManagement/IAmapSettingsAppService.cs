using Letu.Basis.Amaps;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.SettingManagement;

public interface IAmapSettingsAppService : IApplicationService
{
    Task<AmapSettings> GetAsync();

    Task UpdateAsync(AmapSettings input);
}
