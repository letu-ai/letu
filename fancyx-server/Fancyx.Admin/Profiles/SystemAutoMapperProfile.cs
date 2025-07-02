using AutoMapper;
using Fancyx.Admin.Entities.System;
using Fancyx.Admin.IService.Account.Dtos;
using Fancyx.Admin.IService.System.Dtos;

namespace Fancyx.Admin.Profiles
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
