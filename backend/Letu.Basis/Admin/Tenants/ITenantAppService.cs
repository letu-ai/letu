using Letu.Applications;
using Letu.Basis.Admin.Tenants.Dtos;

namespace Letu.Basis.Admin.Tenants
{
    public interface ITenantAppService
    {
        Task AddTenantAsync(TenantCreateOrUpdateInput dto);

        Task<PagedResult<TenantListOutput>> GetTenantListAsync(TenantListInput dto);

        Task UpdateTenantAsync(Guid id, TenantCreateOrUpdateInput dto);

        Task DeleteTenantAsync(Guid id);
    }
}