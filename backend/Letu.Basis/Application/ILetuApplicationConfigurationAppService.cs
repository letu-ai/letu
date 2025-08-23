using Letu.Basis.Application.Dtos;
using Volo.Abp.AspNetCore.Mvc.ApplicationConfigurations;

namespace Letu.Basis.Application;

public interface ILetuApplicationConfigurationAppService : IAbpApplicationConfigurationAppService
{

    Task<LetuApplicationConfigurationDto> GetAsync(LetuApplicationConfigurationRequestOptions options);
}
