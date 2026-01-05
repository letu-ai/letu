using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Shared.Consts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Role.Default)]
[ApiController]
[Route("/api/admin/roles")]
public class RoleController : ControllerBase
{
    private readonly IRoleAppService _roleService;

    public RoleController(IRoleAppService roleService)
    {
        _roleService = roleService;
    }

    /// <summary>
    /// 新增角色
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPost]
    [Authorize(BasisPermissions.Role.Create)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task AddRoleAsync([FromBody] RoleCreateOrUpdateInput dto)
    {
        await _roleService.AddRoleAsync(dto);
    }

    /// <summary>
    /// 角色分页列表
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<PagedResult<RoleListOutput>> GetRoleListAsync([FromQuery] RoleListInput dto)
    {
        return await _roleService.GetRoleListAsync(dto);
    }

    /// <summary>
    /// 修改角色
    /// </summary>
    /// <param name="id"></param>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPut("{id:Guid}")]
    [Authorize(BasisPermissions.Role.Update)]
    public async Task UpdateRoleAsync(Guid id, [FromBody] RoleCreateOrUpdateInput dto)
    {
        await _roleService.UpdateRoleAsync(id, dto);
    }

    /// <summary>
    /// 删除角色
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpDelete("{id:Guid}")]
    [Authorize(BasisPermissions.Role.Delete)]
    public async Task DeleteRoleAsync(Guid id)
    {
        await _roleService.DeleteRoleAsync(id);
    }

    /// <summary>
    /// 获取角色选项
    /// </summary>
    /// <returns></returns>
    [HttpGet("options")]
    public async Task<List<SelectOption>> GetRoleOptionsAsync()
    {
        return await _roleService.GetRoleOptionsAsync();
    }
}