using Letu.Basis.Admin.Settings.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Settings
{
    public interface IConfigService : IScopedDependency
    {
        Task AddConfigAsync(ConfigDto dto);

        Task<PagedResult<ConfigListDto>> GetConfigListAsync(ConfigQueryDto dto);

        Task UpdateConfigAsync(ConfigDto dto);

        Task DeleteConfigAsync(Guid id);
    }
}