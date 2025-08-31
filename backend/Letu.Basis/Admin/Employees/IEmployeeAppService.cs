using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Employees
{
    public interface IEmployeeAppService
    {
        /// <summary>
        /// 新增员工
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddEmployeeAsync(EmployeeCreateOrUpdateInput dto);

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<EmployeeListOutput>> GetEmployeePagedListAsync(EmployeeListInput dto);

        /// <summary>
        /// 修改员工
        /// </summary>
        /// <param name="id"></param>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateEmployeeAsync(Guid id, EmployeeCreateOrUpdateInput dto);

        /// <summary>
        /// 删除员工
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteEmployeeAsync(Guid id);


        /// <summary>
        /// 获取员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<EmployeeInfoDto> GetEmployeeInfoAsync(Guid id);

        /// <summary>
        /// 获取员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<EmployeeCreateOrUpdateInput>> GetEmployeeListAsync(EmployeeListInput dto);

        /// <summary>
        /// 部门+员工树形
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<DeptEmployeeTreeOutput>> GetDeptEmployeeTreeAsync(DeptEmployeeTreeInput dto);

        /// <summary>
        /// 获取员工选项（用于下拉选择）
        /// </summary>
        /// <param name="keyword">搜索关键字</param>
        /// <returns></returns>
        Task<List<EmployeeSelectOption>> GetEmployeeOptionsAsync(string? keyword);

        /// <summary>
        /// 根据用户ID批量获取员工信息（用于编辑时回显）
        /// </summary>
        /// <param name="userIds">用户ID列表</param>
        /// <returns></returns>
        Task<List<EmployeeSelectOption>> GetEmployeesByUserIdsAsync(List<Guid> userIds);
    }
}