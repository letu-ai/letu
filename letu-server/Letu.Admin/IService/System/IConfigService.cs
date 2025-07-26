using Letu.Admin.IService.System.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Admin.IService.System
{
    public interface IConfigService : IScopedDependency
    {
        Task AddConfigAsync(ConfigDto dto);

        Task<PagedResult<ConfigListDto>> GetConfigListAsync(ConfigQueryDto dto);

        Task UpdateConfigAsync(ConfigDto dto);

        Task DeleteConfigAsync(Guid id);
    }
}