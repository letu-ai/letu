using Letu.Basis.Amaps;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;

namespace Letu.Basis.Controllers;

[Authorize]
[ApiController]
[Route("/api/amap")]
public class AmapController : ControllerBase
{
    private readonly IAmapAppService amapAppService;

    public AmapController(IAmapAppService amapAppService)
    {
        this.amapAppService = amapAppService;
    }

    /// <summary>
    /// 高德地图API - 获取所有省份
    /// </summary>
    /// <returns>省份列表</returns>
    [HttpGet("provinces")]
    public async Task<AmapDistrict[]> GetAllProvincesAsync()
    {
        return await amapAppService.GetAllProvincesAsync();
    }

    /// <summary>
    /// 获取行政区域
    /// </summary>
    /// <param name="adCode">行政区代码</param>
    /// <returns>行政区域</returns>
    [HttpGet("district/{adCode}")]
    public async Task<AmapDistrict[]> GetDistrictAsync(string adCode)
    {
        return await amapAppService.GetDistrictAsync(adCode);
    }

    /// <summary>
    /// 获取地理编码
    /// </summary>
    /// <param name="address">地址</param>
    /// <param name="city">城市</param>
    /// <returns>地理编码</returns>
    [HttpGet("geocode")]
    public async Task<AmapGeoCode[]> GetGeoCodeAsync(string address, string city = "")
    {
        return await amapAppService.GetGeoCodeAsync(address, city);
    }

    /// <summary>
    /// 高德地图API - 搜索POI
    /// </summary>
    /// <param name="keywords">关键字</param>
    /// <param name="types">POI类型</param>
    /// <param name="city">城市</param>
    /// <param name="page">页码</param>
    /// <param name="offset">每页记录数</param>
    /// <returns>POI搜索结果</returns>
    [HttpGet("poi")]
    public async Task<AmapPoi[]> SearchPOIAsync(
        string keywords,
        string types = "",
        string city = "",
        int page = 1,
        int offset = 20)
    {
        return await amapAppService.SearchPOIAsync(keywords, types, city, page, offset);
    }

    /// <summary>
    /// 高德地图API - 逆地理编码（坐标转地址）
    /// </summary>
    /// <param name="location">经纬度坐标，格式：longitude,latitude</param>
    /// <returns>逆地理编码结果</returns>
    [HttpGet("regeocode")]
    public async Task<AmapReGeoCode> GetReGeoCodeAsync(string location)
    {
        return await amapAppService.GetReGeoCodeAsync(location);
    }

    /// <summary>
    /// 获取高德地图Web端配置
    /// </summary>
    /// <returns>Web端配置信息</returns>
    [HttpGet("web-config")]
    public async Task<AmapWebConfig> GetWebConfigAsync()
    {
        return await amapAppService.GetWebConfigAsync();
    }
}
