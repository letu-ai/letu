using AutoMapper;
using Letu.Basis.Admin.Roles.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Roles
{
    public class RoleAutoMapperProfile : Profile
    {
        public RoleAutoMapperProfile()
        {
            CreateMap<RoleCreateOrUpdateInput, Role>(MemberList.Source)
                .Ignore(dest=>dest.Id);

            CreateMap<Role, RoleListOutput>();
        }
    }
}