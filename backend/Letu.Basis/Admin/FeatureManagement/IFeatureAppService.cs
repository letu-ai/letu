using System.Threading.Tasks;
using JetBrains.Annotations;
using Letu.Basis.Admin.FeatureManagement.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.FeatureManagement;

public interface IFeatureAppService : IApplicationService
{
    Task<GetFeatureListResultDto> GetAsync([NotNull] string providerName, string? providerKey);

    Task UpdateAsync([NotNull] string providerName, string? providerKey, UpdateFeaturesDto input);

    Task DeleteAsync([NotNull] string providerName, string? providerKey);
}
