using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Core.Applications;


namespace Letu.Basis.Admin.Tenants;

public interface ITenantAppService
{
    Task AddTenantAsync(TenantCreateOrUpdateInput dto);

    Task<PagedResult<TenantListOutput>> GetTenantListAsync(TenantListInput dto);

    Task UpdateTenantAsync(Guid id, TenantCreateOrUpdateInput dto);

    Task DeleteTenantAsync(Guid id);

    Task<string> UploadLogoAsync(Guid id, TenantLogoUploadInput input);

    Task<(Stream?, string)> GetLogoAsync(Guid id, string? logo, CancellationToken cancellationToken = default);
}