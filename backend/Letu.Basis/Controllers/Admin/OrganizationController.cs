using Letu.Basis.Admin.OrganizationUnits;
using Letu.Basis.Admin.OrganizationUnits.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.OrganizationUnit.Default)]
[ApiController]
[Route("api/admin/organization-units")]
public class OrganizationController : ControllerBase
{
    private readonly IOrganizationUnitAppService ouAppService;

    public OrganizationController(IOrganizationUnitAppService ouAppService)
    {
        this.ouAppService = ouAppService;
    }

    /// <summary>
    /// 新增部门
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpPost]
    [Authorize(BasisPermissions.OrganizationUnit.Create)]
    public async Task AddOrganizationUnitAsync([FromBody] OrganizationUnitCreateOrUpdateInput input)
    {
        await ouAppService.AddOrganizationUnitAsync(input);
    }

    /// <summary>
    /// 部门树形列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<List<OrganizationUnitListOutput>> GetOrganizationUnitListAsync([FromQuery] OrganizationUnitListInput input)
    {
        return await ouAppService.GetOrganizationUnitListAsync(input);
    }

    /// <summary>
    /// 修改组织单元
    /// </summary>
    /// <param name="id"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpPut("{id}")]
    [Authorize(BasisPermissions.OrganizationUnit.Update)]
    public async Task UpdateOrganizationUnitAsync(Guid id, [FromBody] OrganizationUnitCreateOrUpdateInput input)
    {
        await ouAppService.UpdateOrganizationUnitAsync(id, input);
    }

    /// <summary>
    /// 删除组织单元
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpDelete("{id:guid}")]
    [Authorize(BasisPermissions.OrganizationUnit.Delete)]
    public async Task DeleteOrganizationUnitAsync(Guid id)
    {
        await ouAppService.DeleteOrganizationUnitAsync(id);
    }
}