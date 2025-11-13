using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.Employee.Default)]
    [ApiController]
    [Route("api/admin/employees")]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeAppService _employeeService;

        public EmployeeController(IEmployeeAppService employeeService)
        {
            _employeeService = employeeService;
        }

        /// <summary>
        /// 新增员工
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.Employee.Create)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task AddEmployeeAsync([FromBody] EmployeeCreateOrUpdateInput dto)
        {
            await _employeeService.AddEmployeeAsync(dto);
        }

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<PagedResult<EmployeeListOutput>> GetEmployeePagedListAsync([FromQuery] EmployeeListInput dto)
        {
            return await _employeeService.GetEmployeePagedListAsync(dto);
        }

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("all")]
        public async Task<List<EmployeeCreateOrUpdateInput>> GetEmployeeListAsync([FromQuery] EmployeeListInput dto)
        {
            return await _employeeService.GetEmployeeListAsync(dto);
        }

        /// <summary>
        /// 修改员工
        /// </summary>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPut("{id:guid}")]
        [Authorize(BasisPermissions.Employee.Update)]
        public async Task UpdateEmployeeAsync(Guid id, [FromBody] EmployeeCreateOrUpdateInput input)
        {
            await _employeeService.UpdateEmployeeAsync(id, input);
        }

        /// <summary>
        /// 删除员工
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:guid}")]
        [Authorize(BasisPermissions.Employee.Delete)]
        public async Task DeleteEmployeeAsync(Guid id)
        {
            await _employeeService.DeleteEmployeeAsync(id);
        }


        /// <summary>
        /// 获取员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id:guid}/info")]
        public async Task<EmployeeInfoDto> GetEmployeeInfoAsync(Guid id)
        {
            return await _employeeService.GetEmployeeInfoAsync(id);
        }

        /// <summary>
        /// 部门+员工树形
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("dept-employee-tree")]
        public async Task<List<DeptEmployeeTreeOutput>> GetDeptEmployeeTreeAsync([FromQuery] DeptEmployeeTreeInput dto)
        {
            return await _employeeService.GetDeptEmployeeTreeAsync(dto);
        }

        /// <summary>
        /// 获取员工选项（用于下拉选择）
        /// </summary>
        /// <param name="keyword">搜索关键字</param>
        /// <returns></returns>
        [HttpGet("select-options")]
        public async Task<List<EmployeeSelectOption>> GetEmployeeOptionsAsync([FromQuery] string? keyword)
        {
            return await _employeeService.GetEmployeeOptionsAsync(keyword);
        }

        /// <summary>
        /// 根据用户ID批量获取员工信息（用于编辑时回显）
        /// </summary>
        /// <param name="userIds">用户ID列表</param>
        /// <returns></returns>
        [HttpPost("select-options/by-ids")]
        public async Task<List<EmployeeSelectOption>> GetEmployeesByUserIdsAsync([FromBody] List<Guid> userIds)
        {
            return await _employeeService.GetEmployeesByUserIdsAsync(userIds);
        }
    }
}