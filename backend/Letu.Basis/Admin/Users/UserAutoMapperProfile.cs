using AutoMapper;
using Letu.Basis.Admin.Users.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Users
{
    public class UserAutoMapperProfile : Profile
    {
        public UserAutoMapperProfile()
        {
            CreateMap<UserCreateOrUpdateInput, User>(MemberList.Source)
                .Ignore(dest=>dest.PasswordSalt)
                .Ignore(dest=>dest.Id);

            CreateMap<User, UserListOutput>();
        }
    }
}