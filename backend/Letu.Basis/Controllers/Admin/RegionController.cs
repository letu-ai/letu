using Letu.Basis.Admin.Regions;
using Letu.Basis.Admin.Regions.Dtos;
using Letu.Basis.Permissions;
using Letu.Logging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Region.Default)]
[ApiController]
[Route("api/admin/regions")]
public class RegionController : ControllerBase
{
    private readonly IRegionAppService regionAppService;

    public RegionController(IRegionAppService regionAppService)
    {
        this.regionAppService = regionAppService;
    }

    /// <summary>
    /// 新增行政区域
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpPost]
    [Authorize(BasisPermissions.Region.Create)]
    public async Task<RegionListOutput> AddRegionAsync([FromBody] RegionCreateOrUpdateInput input)
    {
        return await regionAppService.AddRegionAsync(input);
    }

    /// <summary>
    /// 根据父级代码获取子区域
    /// </summary>
    /// <param name="parentId">父级区域ID</param>
    /// <returns></returns>
    [HttpGet("children/{parentId?}")]
    public async Task<List<RegionListOutput>> GetChildrenAsync(int? parentId)
    {
        return await regionAppService.GetChildrenAsync(parentId);
    }

    /// <summary>
    /// 根据代码获取行政区域
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    [HttpGet("by-code/{code}")]
    public async Task<RegionListOutput?> GetRegionByCodeAsync(string code)
    {
        return await regionAppService.GetRegionByCodeAsync(code);
    }

    /// <summary>
    /// 从高德地图API导入行政区域数据
    /// </summary>
    /// <returns></returns>
    [HttpPost("import-from-amap")]
    [Authorize(BasisPermissions.Region.Import)]
    public async Task<RegionImportResultDto> ImportFromAmapAsync()
    {
        return await regionAppService.ImportFromAmapAsync();
    }

    /// <summary>
    /// 获取导入进度
    /// </summary>
    /// <returns></returns>
    [HttpGet("import-progress")]
    public async Task<RegionImportProgressDto> GetImportProgressAsync()
    {
        return await regionAppService.GetImportProgressAsync();
    }

    /// <summary>
    /// 修改行政区域
    /// </summary>
    /// <param name="id"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpPut("{id}")]
    [Authorize(BasisPermissions.Region.Update)]
    public async Task<RegionListOutput> UpdateRegionAsync(int id, [FromBody] RegionCreateOrUpdateInput input)
    {
        return await regionAppService.UpdateRegionAsync(id, input);
    }

    /// <summary>
    /// 删除行政区域
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpDelete("{id:int}")]
    [Authorize(BasisPermissions.Region.Delete)]
    [ApiAccessLog(operateName: "删除行政区域", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task DeleteRegionAsync(int id)
    {
        await regionAppService.DeleteRegionAsync(id);
    }
}