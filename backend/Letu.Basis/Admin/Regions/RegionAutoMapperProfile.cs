using AutoMapper;
using Letu.Basis.Admin.Regions.Dtos;

namespace Letu.Basis.Admin.Regions;

public class RegionAutoMapperProfile : Profile
{
    public RegionAutoMapperProfile()
    {
        CreateMap<Region, RegionListOutput>();

        CreateMap<Street, StreetListOutput>();
    }
}