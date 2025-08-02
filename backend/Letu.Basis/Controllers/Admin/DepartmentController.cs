using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Departments.Dtos;
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
    [Route("api/admin/departments")]
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentAppService _deptService;

        public DepartmentController(IDepartmentAppService deptService)
        {
            _deptService = deptService;
        }

        /// <summary>
        /// 新增部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [HasPermission("Org.Dept.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task AddDeptAsync([FromBody] DeptDto dto)
        {
            await _deptService.AddDeptAsync(dto);
        }

        /// <summary>
        /// 部门树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Org.Dept.List")]
        public async Task<List<DeptListDto>> GetDeptListAsync([FromQuery] DeptQueryDto dto)
        {
            return await _deptService.GetDeptListAsync(dto);
        }

        /// <summary>
        /// 修改部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut]
        [HasPermission("Org.Dept.Update")]
        public async Task UpdateDeptAsync([FromBody] DeptDto dto)
        {
            await _deptService.UpdateDeptAsync(dto);
        }

        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:guid}")]
        [HasPermission("Org.Dept.Delete")]
        [ApiAccessLog(operateName: "删除部门", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteDeptAsync(Guid id)
        {
            await _deptService.DeleteDeptAsync(id);
        }
    }
}