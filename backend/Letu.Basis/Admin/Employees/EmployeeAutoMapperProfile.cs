using AutoMapper;
using Letu.Basis.Admin.Employees.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Employees
{
    public class EmployeeAutoMapperProfile : Profile
    {
        public EmployeeAutoMapperProfile()
        {
            // 在AutoMapper中，忽略源端属性（源对象的属性）没有像忽略目标对象属性（.ForMember(..., opt => opt.Ignore())）那样的写法。
            // 忽略源端属性通常用 .ForSourceMember(..., opt => opt.DoNotValidate()) 或 .ForSourceMember(..., opt => opt.Ignore())。
            // 这里的写法已经是标准做法。
            CreateMap<EmployeeCreateOrUpdateInput, Employee>(MemberList.Source)
                .Ignore(dest => dest.Id)
                .ForSourceMember(src => src.IsAddUser, opt => opt.DoNotValidate())
                .ForSourceMember(src => src.UserPassword, opt => opt.DoNotValidate());

            CreateMap<Employee, EmployeeInfoDto>()
                .Ignore(dest=>dest.UserName)
                .Ignore(dest=>dest.NickName)
                .Ignore(dest=>dest.DeptName)
                .Ignore(dest=>dest.PositionName);
        }
    }
}