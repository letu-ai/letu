using AutoMapper;
using Letu.Basis.Admin.OrganizationUnits.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.OrganizationUnits;

public class OrganizationUnitAutoMapperProfile : Profile
{
    public OrganizationUnitAutoMapperProfile()
    {
        CreateMap<OrganizationUnitCreateOrUpdateInput, OrganizationUnit>(MemberList.Source)
            .Ignore(dest => dest.Id);

        CreateMap<OrganizationUnit, OrganizationUnitListOutput>();
    }
}