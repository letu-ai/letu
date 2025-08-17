using Letu.Basis.Admin.SettingManagement.Dtos;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.SettingManagement;

public interface IEmailSettingsAppService : IApplicationService
{
    Task<EmailSettingsDto> GetAsync();

    Task UpdateAsync(UpdateEmailSettingsDto input);

    Task SendTestEmailAsync(SendTestEmailInput input);
}
