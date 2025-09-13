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
    private readonly IStreetAppService streetAppService;

    public RegionController(IRegionAppService regionAppService, IStreetAppService streetAppService)
    {
        this.regionAppService = regionAppService;
        this.streetAppService = streetAppService;
    }

    /// <summary>
    /// 根据代码获取行政区域
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    [HttpGet("by-code/{code}")]
    public async Task<RegionListOutput> GetRegionByCodeAsync(string code)
    {
        return await regionAppService.GetRegionByCodeAsync(code);
    }

    /// <summary>
    /// 根据父级代码获取子级区域
    /// </summary>
    /// <param name="parentCode">父级区域代码，空值表示获取顶级</param>
    /// <returns></returns>
    [HttpGet("children-by-code/{parentCode?}")]
    public async Task<List<RegionListOutput>> GetChildrenByCodeAsync(string? parentCode = null)
    {
        return await regionAppService.GetChildrenByCodeAsync(parentCode);
    }

    /// <summary>
    /// 根据代码获取区域的完整路径
    /// </summary>
    /// <param name="code">区域代码</param>
    /// <returns>从顶级到当前区域的完整路径</returns>
    [HttpGet("path-by-code/{code}")]
    public async Task<List<RegionListOutput>> GetPathByCodeAsync(string code)
    {
        return await regionAppService.GetPathByCodeAsync(code);
    }

    /// <summary>
    /// 从高德地图API导入行政区域数据
    /// </summary>
    /// <returns></returns>
    [HttpPost("import-from-amap")]
    [Authorize(BasisPermissions.Region.Import)]
    public async Task<RegionImportResultDto> ImportFromAmapAsync(bool includeStreets)
    {
        return await regionAppService.ImportFromAmapAsync(includeStreets);
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
    /// 根据区域代码获取街道名称列表
    /// </summary>
    /// <param name="regionCode">区域代码</param>
    /// <returns>街道名称列表</returns>
    [HttpGet("streets/{regionCode}")]
    public async Task<List<string>> GetStreetsAsync(string regionCode)
    {
        return (await streetAppService.GetStreetsAsync(regionCode)).Select(x=>x.Name).ToList();
    }
}