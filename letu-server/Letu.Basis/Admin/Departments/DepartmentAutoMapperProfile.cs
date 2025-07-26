using AutoMapper;
using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Positions.Dtos;

namespace Letu.Basis.Profiles
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