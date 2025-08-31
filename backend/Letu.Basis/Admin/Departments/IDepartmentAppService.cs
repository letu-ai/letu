using Letu.Basis.Admin.Departments.Dtos;
using Letu.Core.Applications;


namespace Letu.Basis.Admin.Departments
{
    public interface IDepartmentAppService
    {
        /// <summary>
        /// 新增部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddDeptAsync(DepartmentCreateOrUpdateInput dto);

        /// <summary>
        /// 部门树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<DepartmentListOutput>> GetDeptListAsync(DeptQueryDto dto);

        /// <summary>
        /// 修改部门
        /// </summary>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<bool> UpdateDeptAsync(Guid id, DepartmentCreateOrUpdateInput input);

        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteDeptAsync(Guid id);

        /// <summary>
        /// 获取部门树形选项列表（用于下拉选择器）
        /// </summary>
        /// <returns></returns>
        Task<List<TreeSelectOption>> GetDeptTreeOptionsAsync();
    }
}