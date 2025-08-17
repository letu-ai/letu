using AutoMapper;
using Letu.Basis.Admin.Departments.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Departments
{
    public class DepartmentAutoMapperProfile : Profile
    {
        public DepartmentAutoMapperProfile()
        {
            CreateMap<DepartmentCreateOrUpdateInput, Department>(MemberList.Source)
                .Ignore(dest=>dest.Id);

            CreateMap<Department, DepartmentListOutput>()
                .Ignore(dest=>dest.CuratorName);
        }
    }
}