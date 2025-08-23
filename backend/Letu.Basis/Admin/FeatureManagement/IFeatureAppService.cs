using JetBrains.Annotations;
using Letu.Basis.Admin.FeatureManagement.Dtos;
using Letu.Core.Applications;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.FeatureManagement;

public interface IFeatureAppService : IApplicationService
{
    Task<GetFeatureListResultDto> GetAsync([NotNull] string providerName, string? providerKey);

    Task UpdateAsync([NotNull] string providerName, string? providerKey, UpdateFeaturesDto input);

    Task DeleteAsync([NotNull] string providerName, string? providerKey);

    /// <summary>
    /// 获取所有功能选项
    /// </summary>
    /// <param name="valueType">可选的值类型过滤</param>
    /// <returns></returns>
    Task<List<SelectOption>> GetSelectOptionsAsync(string? valueType = null);
}
