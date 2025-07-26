using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Tenants
{
    public interface ITenantAppService : IScopedDependency
    {
        Task AddTenantAsync(TenantDto dto);

        Task<PagedResult<TenantResultDto>> GetTenantListAsync(TenantSearchDto dto);

        Task UpdateTenantAsync(TenantDto dto);

        Task DeleteTenantAsync(Guid id);
    }
}