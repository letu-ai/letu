using AutoMapper;
using Letu.Admin.Entities.System;
using Letu.Admin.IService.Account.Dtos;
using Letu.Admin.IService.System.Dtos;

namespace Letu.Admin.Profiles
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
