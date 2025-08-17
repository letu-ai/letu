using AutoMapper;
using Letu.Basis.Admin.Tenants.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Tenants;

public class TenantAutoMapperProfile : Profile
{
    public TenantAutoMapperProfile()
    {
        CreateMap<Tenant, TenantListOutput>()
            .Ignore(dest=>dest.EditionName);
    }
}
