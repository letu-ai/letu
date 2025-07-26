using AutoMapper;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Positions.Dtos;

namespace Letu.Basis.Admin.Departments
{
    public class DepartmentAutoMapperProfile : Profile
    {
        public DepartmentAutoMapperProfile()
        {
            CreateMap<DeptDto, Department>();
            CreateMap<Department, DeptListDto>();
        }
    }
}