using AutoMapper;
using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Positions.Dtos;

namespace Letu.Basis.Profiles
{
    public class PositionAutoMapperProfile : Profile
    {
        public PositionAutoMapperProfile()
        {
            CreateMap<PositionGroupDto, PositionGroup>();
            CreateMap<PositionGroup, PositionGroupListDto>()
                .ForMember(d => d.Rawchildren, o => o.MapFrom(s => s.Children));
            CreateMap<Position, PositionListDto>();
            CreateMap<PositionDto, Position>();
        }
    }
}