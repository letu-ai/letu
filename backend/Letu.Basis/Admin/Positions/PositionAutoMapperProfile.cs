using AutoMapper;
using Letu.Basis.Admin.Positions.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Positions
{
    public class PositionAutoMapperProfile : Profile
    {
        public PositionAutoMapperProfile()
        {
            CreateMap<PositionGroupCreateOrUpdateInput, PositionGroup>(MemberList.Source)
                .Ignore(d => d.Id);

            CreateMap<PositionGroup, PositionGroupListOutput>()
                .ForMember(d => d.Children, opt =>
                {
                    opt.Condition(src => src.Children != null && src.Children.Count > 0); // 没有Children时不映射
                    opt.MapFrom(src => src.Children);
                });

            CreateMap<Position, PositionListOutput>()
                .Ignore(dest=>dest.LayerName);

            CreateMap<PositionCreateOrUpdateInput, Position>(MemberList.Source);
        }
    }
}