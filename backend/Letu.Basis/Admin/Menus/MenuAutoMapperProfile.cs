using AutoMapper;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Shared.Models;

namespace Letu.Basis.Admin.Menus
{
    public class MenuAutoMapperProfile : Profile
    {
        public MenuAutoMapperProfile()
        {
            CreateMap<MenuCreateOrUpdateInput, MenuItem>();
            CreateMap<MenuItem, MenuListOutput>();
            CreateMap<MenuItem, FrontendMenu>();
        }
    }
}