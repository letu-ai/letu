using Fancyx.Admin.IService.Organization.Dtos;

namespace Fancyx.Admin.IService.Organization
{
    public interface IEmployeeService
    {
        /// <summary>
        /// 新增员工
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddEmployeeAsync(EmployeeDto dto);

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<EmployeeListDto>> GetEmployeePagedListAsync(EmployeeQueryDto dto);

        /// <summary>
        /// 修改员工
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateEmployeeAsync(EmployeeDto dto);

        /// <summary>
        /// 删除员工
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteEmployeeAsync(Guid id);

        /// <summary>
        /// 绑定用户
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task EmployeeBindUserAsync(EmployeeBindUserDto dto);

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
        Task<List<EmployeeDto>> GetEmployeeListAsync(EmployeeQueryDto dto);

        /// <summary>
        /// 部门+员工树形
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<DeptEmployeeTreeDto>> GetDeptEmployeeTreeAsync(DeptEmployeeTreeQueryDto dto);
    }
}