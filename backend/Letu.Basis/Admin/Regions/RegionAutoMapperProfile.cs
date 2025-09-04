using AutoMapper;
using Letu.Basis.Admin.Regions.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Regions;

public class RegionAutoMapperProfile : Profile
{
    public RegionAutoMapperProfile()
    {
        CreateMap<Region, RegionListOutput>();
        CreateMap<RegionCreateOrUpdateInput, Region>(MemberList.Source)
            .Ignore(d => d.Id)
            .Ignore(d => d.Level); // Level由后端根据父级关系自动计算
    }
}