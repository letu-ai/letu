using Letu.Applications;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Core.Attributes;
using Letu.Logging;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
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
        [HasPermission("Org.Employee.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task AddEmployeeAsync([FromBody] EmployeeDto dto)
        {
            await _employeeService.AddEmployeeAsync(dto);
        }

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Org.Employee.List")]
        public async Task<PagedResult<EmployeeListDto>> GetEmployeePagedListAsync([FromQuery] EmployeeQueryDto dto)
        {
            return await _employeeService.GetEmployeePagedListAsync(dto);
        }

        /// <summary>
        /// 员工列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("all")]
        public async Task<List<EmployeeDto>> GetEmployeeListAsync([FromQuery] EmployeeQueryDto dto)
        {
            return await _employeeService.GetEmployeeListAsync(dto);
        }

        /// <summary>
        /// 修改员工
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut]
        [HasPermission("Org.Employee.Update")]
        public async Task UpdateEmployeeAsync([FromBody] EmployeeDto dto)
        {
            await _employeeService.UpdateEmployeeAsync(dto);
        }

        /// <summary>
        /// 删除员工
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:guid}")]
        [HasPermission("Org.Employee.Delete")]
        [ApiAccessLog(operateName: "删除员工", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteEmployeeAsync(Guid id)
        {
            await _employeeService.DeleteEmployeeAsync(id);
        }

        /// <summary>
        /// 绑定用户
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("bind-user")]
        [HasPermission("Org.Employee.BindUser")]
        public async Task EmployeeBindUserAsync([FromBody] EmployeeBindUserDto dto)
        {
            await _employeeService.EmployeeBindUserAsync(dto);
        }

        /// <summary>
        /// 获取员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id:guid}/info")]
        [HasPermission("Org.Employee.List")]
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
        public async Task<List<DeptEmployeeTreeDto>> GetDeptEmployeeTreeAsync([FromQuery] DeptEmployeeTreeQueryDto dto)
        {
            return await _employeeService.GetDeptEmployeeTreeAsync(dto);
        }
    }
}