using AutoMapper;
using Letu.Basis.Admin.Positions.Dtos;

namespace Letu.Basis.Admin.Positions
{
    public class PositionAutoMapperProfile : Profile
    {
        public PositionAutoMapperProfile()
        {
            CreateMap<PositionGroupCreateOrUpdateInput, PositionGroup>();
            CreateMap<PositionGroup, PositionGroupListOutput>()
                .ForMember(d => d.Children, opt =>
                {
                    opt.Condition(src => src.Children != null && src.Children.Count > 0); // 没有Children时不映射
                    opt.MapFrom(src => src.Children);
                });

            CreateMap<Position, PositionListOutput>();
            CreateMap<PositionCreateOrUpdateInput, Position>();
        }
    }
}