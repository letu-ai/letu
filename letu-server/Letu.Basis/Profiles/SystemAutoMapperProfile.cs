using AutoMapper;
using Letu.Basis.Entities.System;
using Letu.Basis.IService.Account.Dtos;
using Letu.Basis.IService.System.Dtos;

namespace Letu.Basis.Profiles
{
    public class SystemAutoMapperProfile : Profile
    {
        public SystemAutoMapperProfile()
        {
            CreateMap<TokenResultDto, LoginResultDto>();
            CreateMap<MenuDto, MenuDO>();
            CreateMap<MenuDO, MenuListDto>();
            CreateMap<DictDataDto, DictDataDO>();
            CreateMap<MenuDO, FrontendMenu>();
        }
    }
}
