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
}