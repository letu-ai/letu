using Letu.Basis.Admin.Tenants;
using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Logging;
using Letu.Shared.Consts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

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
    public async Task DeleteTenantAsync([FromRoute] Guid id)
    {
        await tenantService.DeleteTenantAsync(id);
    }

    /// <summary>
    /// 获取租户Logo
    /// </summary>
    /// <param name="id">租户ID</param>
    /// <param name="logo">租户Logo</param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    [HttpGet("{id:guid}/{*logo}")]
    public async Task<IActionResult> GetTenantLogoAsync(Guid id, string logo, CancellationToken cancellationToken = default)
    {
        var (stream, contentType) = await tenantService.GetLogoAsync(id, logo, cancellationToken);
        if (stream == null)
        {
            return NotFound();
        }

        return File(stream, contentType);
    }

    /// <summary>
    /// 上传租户Logo
    /// </summary>
    /// <param name="id">租户ID</param>
    /// <param name="input">租户Logo上传输入</param>
    /// <returns></returns>
    [HttpPut("{id:guid}/logo")]
    [Authorize(BasisPermissions.Tenant.Update)]
    [RequestSizeLimit(10_000_000)]
    public async Task<string> UploadTenantLogoAsync(Guid id, TenantLogoUploadInput input)
    {
        return await tenantService.UploadLogoAsync(id, input);
    }
}