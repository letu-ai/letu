using Letu.Basis.Admin.Departments.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Departments
{
    public interface IDepartmentAppService : IScopedDependency
    {
        /// <summary>
        /// 新增部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddDeptAsync(DeptDto dto);

        /// <summary>
        /// 部门树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<DeptListDto>> GetDeptListAsync(DeptQueryDto dto);

        /// <summary>
        /// 修改部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateDeptAsync(DeptDto dto);

        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteDeptAsync(Guid id);
    }
}