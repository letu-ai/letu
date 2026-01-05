using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Department.Default)]
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
    [Authorize(BasisPermissions.Department.Create)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task AddDeptAsync([FromBody] DepartmentCreateOrUpdateInput dto)
    {
        await _deptService.AddDeptAsync(dto);
    }

    /// <summary>
    /// 部门树形列表
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<List<DepartmentListOutput>> GetDeptListAsync([FromQuery] DeptQueryDto dto)
    {
        return await _deptService.GetDeptListAsync(dto);
    }

    /// <summary>
    /// 修改部门
    /// </summary>
    /// <param name="id"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpPut("{id}")]
    [Authorize(BasisPermissions.Department.Update)]
    public async Task UpdateDeptAsync(Guid id, [FromBody] DepartmentCreateOrUpdateInput input)
    {
        await _deptService.UpdateDeptAsync(id, input);
    }

    /// <summary>
    /// 删除部门
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpDelete("{id:guid}")]
    [Authorize(BasisPermissions.Department.Delete)]
    public async Task DeleteDeptAsync(Guid id)
    {
        await _deptService.DeleteDeptAsync(id);
    }

    /// <summary>
    /// 获取部门树形选项列表（用于下拉选择器）
    /// </summary>
    /// <returns></returns>
    [HttpGet("tree-options")]
    public async Task<List<TreeSelectOption>> GetDeptTreeOptionsAsync()
    {
        return await _deptService.GetDeptTreeOptionsAsync();
    }
}