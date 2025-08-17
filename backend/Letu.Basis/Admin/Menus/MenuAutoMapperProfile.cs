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
            CreateMap<MenuCreateOrUpdateInput, MenuItem>(MemberList.Source)
                .Ignore(d=>d.Id);

            CreateMap<MenuItem, MenuListOutput>()
                .Ignore(dest=>dest.Children);

            CreateMap<MenuItem, FrontendMenu>()
                .Ignore(dest=>dest.LayerName)
                .Ignore(dest=>dest.Children);
            
        }
    }
}