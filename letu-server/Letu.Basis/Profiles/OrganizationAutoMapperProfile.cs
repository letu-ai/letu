using AutoMapper;

using Letu.Basis.Entities.Organization;
using Letu.Basis.IService.Organization.Dtos;

namespace Letu.Basis.Profiles
{
    public class OrganizationAutoMapperProfile : Profile
    {
        public OrganizationAutoMapperProfile()
        {
            CreateMap<EmployeeDto, EmployeeDO>();
            CreateMap<DeptDto, DeptDO>();
            CreateMap<DeptDO, DeptListDto>();
            CreateMap<PositionGroupDto, PositionGroupDO>();
            CreateMap<PositionGroupDO, PositionGroupListDto>()
                .ForMember(d => d.Rawchildren, o => o.MapFrom(s => s.Children));
            CreateMap<PositionDO, PositionListDto>();
            CreateMap<PositionDto, PositionDO>();
            CreateMap<EmployeeDO, EmployeeInfoDto>();
        }
    }
}