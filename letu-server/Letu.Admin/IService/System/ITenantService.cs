using Letu.Admin.IService.System.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Admin.IService.System
{
    public interface ITenantService : IScopedDependency
    {
        Task AddTenantAsync(TenantDto dto);

        Task<PagedResult<TenantResultDto>> GetTenantListAsync(TenantSearchDto dto);

        Task UpdateTenantAsync(TenantDto dto);

        Task DeleteTenantAsync(Guid id);
    }
}