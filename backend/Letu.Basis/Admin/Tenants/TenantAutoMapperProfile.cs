using AutoMapper;
using Letu.Basis.Admin.Tenants.Dtos;
using Volo.Abp.AutoMapper;
using Volo.Abp.Data;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Tenants;

public class TenantAutoMapperProfile : Profile
{
    public TenantAutoMapperProfile()
    {
        CreateMap<Tenant, TenantListOutput>()
            .Ignore(dest=>dest.EditionName);

        CreateMap<Tenant, TenantConfiguration>()
            .ForMember(ti => ti.ConnectionStrings, opts =>
            {
                opts.MapFrom((tenant, ti) =>
                {
                    var connStrings = new ConnectionStrings();

                    // TODO: 待增加ConnectionString属性
                    //if (tenant.ConnectionStrings == null)
                    //{
                    //    return connStrings;
                    //}

                    //foreach (var connectionString in tenant.ConnectionStrings)
                    //{
                    //    connStrings[connectionString.Name] = connectionString.Value;
                    //}

                    return connStrings;
                });
            })
            .ForMember(x => x.IsActive, x => x.Ignore());
    }
}
