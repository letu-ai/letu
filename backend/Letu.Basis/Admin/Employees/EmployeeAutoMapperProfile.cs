using AutoMapper;
using Letu.Basis.Admin.Employees.Dtos;

namespace Letu.Basis.Admin.Employees
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