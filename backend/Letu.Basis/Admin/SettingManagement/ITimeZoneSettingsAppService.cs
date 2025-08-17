using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.SettingManagement;

public interface ITimeZoneSettingsAppService : IApplicationService
{
    Task<string> GetAsync();

    Task<List<NameValue>> GetTimezonesAsync();

    Task UpdateAsync(string timezone);
}
