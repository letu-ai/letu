using AutoMapper;
using Letu.Basis.Admin.DataDictionary;
using Letu.Basis.Admin.Menus;
using Letu.Basis.IService.Account.Dtos;
using Letu.Basis.IService.System.Dtos;

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
