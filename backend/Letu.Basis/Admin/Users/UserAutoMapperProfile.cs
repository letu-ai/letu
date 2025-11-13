using AutoMapper;
using Letu.Basis.Admin.Users.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Users;

public class UserAutoMapperProfile : Profile
{
    public UserAutoMapperProfile()
    {
        CreateMap<UserCreateInput, User>(MemberList.Source)
            .ForSourceMember(s => s.TagIds, opt => opt.DoNotValidate())
            .ForSourceMember(s => s.Password, opt => opt.DoNotValidate())
            .ForSourceMember(s => s.UserName, opt => opt.DoNotValidate());

        CreateMap<UserUpdateInput, User>(MemberList.Source)
            .ForSourceMember(s => s.TagIds, opt => opt.DoNotValidate());

        CreateMap<User, UserListOutput>()
            .Ignore(d => d.Tags)
            .Ignore(d => d.OrganizationUnitName)
            .Ignore(d => d.DepartmentName)
            .Ignore(d => d.PositionName)
            .Ignore(d => d.EmployeeName);
    }
}