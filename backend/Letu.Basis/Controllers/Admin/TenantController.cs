using Letu.Basis.Admin.Tenants;
using Letu.Basis.Admin.Tenants.Dtos;

using Letu.Logging;
using Letu.Shared.Consts;
using Letu.Shared.Models;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Letu.Basis.Permissions;
using Letu.Core.Applications;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Tenant.Default)]
[ApiController]
[Route("api/admin/tenants")]
public class TenantController : ControllerBase
{
    private readonly ITenantAppService tenantService;

    public TenantController(ITenantAppService tenantService)
    {
        this.tenantService = tenantService;
    }

    /// <summary>
    /// 添加租户
    /// </summary>
    /// <param name="dto">租户信息</param>
    /// <returns></returns>
    [HttpPost]
    [Authorize(BasisPermissions.Tenant.Create)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    [ApiAccessLog(operateName: "添加租户", operateType: [OperateType.Create], reponseEnable: true)]
    public async Task AddTenantAsync([FromBody] TenantCreateOrUpdateInput dto)
    {
        await tenantService.AddTenantAsync(dto);
    }

    /// <summary>
    /// 分页列表
    /// </summary>
    /// <param name="dto">查询条件</param>
    /// <returns>租户列表</returns>
    [HttpGet]
    public async Task<PagedResult<TenantListOutput>> GetTenantListAsync([FromQuery] TenantListInput dto)
    {
        var data = await tenantService.GetTenantListAsync(dto);
        return data;
    }

    /// <summary>
    /// 修改租户
    /// </summary>
    /// <param name="id">租户ID</param>
    /// <param name="dto">租户信息</param>
    /// <returns></returns>
    [HttpPut("{id:guid}")]
    [Authorize(BasisPermissions.Tenant.Update)]
    [ApiAccessLog(operateName: "修改租户", operateType: [OperateType.Update], reponseEnable: true)]
    public async Task UpdateTenantAsync([FromRoute] Guid id, [FromBody] TenantCreateOrUpdateInput dto)
    {
        await tenantService.UpdateTenantAsync(id, dto);
    }

    /// <summary>
    /// 删除租户
    /// </summary>
    /// <param name="id">租户ID</param>
    /// <returns></returns>
    [HttpDelete("{id:guid}")]
    [Authorize(BasisPermissions.Tenant.Delete)]
    [ApiAccessLog(operateName: "删除租户", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task DeleteTenantAsync([FromRoute] Guid id)
    {
        await tenantService.DeleteTenantAsync(id);
    }
}