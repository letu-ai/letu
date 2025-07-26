using AutoMapper;
using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Positions;
using Letu.Basis.IService.Organization.Dtos;

namespace Letu.Basis.Profiles
{
    public class OrganizationAutoMapperProfile : Profile
    {
        public OrganizationAutoMapperProfile()
        {
            CreateMap<EmployeeDto, Employee>();
            CreateMap<DeptDto, Department>();
            CreateMap<Department, DeptListDto>();
            CreateMap<PositionGroupDto, PositionGroup>();
            CreateMap<PositionGroup, PositionGroupListDto>()
                .ForMember(d => d.Rawchildren, o => o.MapFrom(s => s.Children));
            CreateMap<Position, PositionListDto>();
            CreateMap<PositionDto, Position>();
            CreateMap<Employee, EmployeeInfoDto>();
        }
    }
}