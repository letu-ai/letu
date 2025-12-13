using AutoMapper;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.Admin.UserTags.Dtos;
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
            .ForMember(d=>d.Tags, opt => {
                opt.Condition(src => src.Tags != null && src.Tags.Count > 0);
                opt.MapFrom(src => src.Tags!.Select(t => new UserTagInfo{
                    Id = t.Id,
                    Name = t.Name,
                    Color = t.Color
                }).ToList());
            })
            .ForMember(d=>d.Roles, opt => {
                opt.Condition(src => src.Roles != null && src.Roles.Count > 0);
                opt.MapFrom(src => src.Roles!.Select(r => r.Name).ToList());
            })
            .ForMember(d=>d.OrganizationUnitName, opt => {
                opt.Condition(src => src.OrganizationUnit != null);
                opt.MapFrom(src => src.OrganizationUnit!.Name);
            })
            .ForMember(d=>d.DepartmentName, opt => {
                opt.Condition(src => src.Department != null);
                opt.MapFrom(src => src.Department!.Name);
            })
            .ForMember(d=>d.PositionName, opt => {
                opt.Condition(src => src.Position != null);
                opt.MapFrom(src => src.Position!.Name);
            })
            .ForMember(d=>d.EmployeeName, opt => {
                opt.Condition(src => src.Employee != null);
                opt.MapFrom(src => src.Employee!.Name);
            });
    }
}