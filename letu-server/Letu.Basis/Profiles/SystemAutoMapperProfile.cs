using AutoMapper;
using Letu.Basis.Account.Dtos;
using Letu.Basis.Admin.DataDictionary;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Menus.Dtos;

namespace Letu.Basis.Profiles
{
    public class SystemAutoMapperProfile : Profile
    {
        public SystemAutoMapperProfile()
        {
            CreateMap<TokenResultDto, LoginResultDto>();
            CreateMap<MenuDto, MenuItem>();
            CreateMap<MenuItem, MenuListDto>();
            CreateMap<DictDataDto, DictionaryItem>();
            CreateMap<MenuItem, FrontendMenu>();
        }
    }
}
