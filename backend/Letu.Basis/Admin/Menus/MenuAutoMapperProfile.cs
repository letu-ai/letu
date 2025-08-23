using AutoMapper;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Shared.Models;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Menus
{
    public class MenuAutoMapperProfile : Profile
    {
        public MenuAutoMapperProfile()
        {
            CreateMap<MenuItemCreateOrUpdateInput, MenuItem>(MemberList.Source)
                .Ignore(d=>d.Id)
                .Ignore(d=>d.Permissions)
                .Ignore(d=>d.Features)
                .ForSourceMember(s => s.Permissions, opt => opt.DoNotValidate())
                .ForSourceMember(s => s.Features, opt => opt.DoNotValidate());

            CreateMap<MenuItem, MenuItemListOutput>()
                .Ignore(dest=>dest.Children)
                .Ignore(dest=>dest.PermissionDisplayNames)
                .Ignore(dest=>dest.FeatureDisplayNames)
                .ForMember(dest => dest.Permissions, opt => opt.MapFrom(src => 
                    src.Permissions != null && src.Permissions.Count > 0 
                        ? src.Permissions.Select(p => p.Permission).ToArray() 
                        : new string[0]))
                .ForMember(dest => dest.Features, opt => opt.MapFrom(src => 
                    src.Features != null && src.Features.Count > 0 
                        ? src.Features.Select(f => f.Feature).ToArray() 
                        : new string[0]));

            CreateMap<MenuItem, NavigationMenuDto>();

            CreateMap<MenuItem, FrontendMenu>()
                .Ignore(dest=>dest.LayerName)
                .Ignore(dest=>dest.Children);
            
        }
    }
}