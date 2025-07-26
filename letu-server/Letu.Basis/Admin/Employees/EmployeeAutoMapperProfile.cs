using AutoMapper;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;

namespace Letu.Basis.Profiles
{
    public class EmployeeAutoMapperProfile : Profile
    {
        public EmployeeAutoMapperProfile()
        {
            CreateMap<EmployeeDto, Employee>();
            CreateMap<Employee, EmployeeInfoDto>();
        }
    }
}