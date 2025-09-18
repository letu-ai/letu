namespace Letu.Basis.Amaps;

public interface IAmapAppService
{
    Task<AmapDistrict[]> GetAllProvincesAsync();

    /// <summary>
    /// 高德地图API - 行政区域查询
    /// </summary>
    /// <param name="adCode">查询级行政区代码</param>
    /// <returns>行政区域信息</returns>
    Task<AmapDistrict[]> GetDistrictAsync(string adCode);

    /// <summary>
    /// 高德地图API - 地理编码（地址转坐标）
    /// </summary>
    /// <param name="address">地址</param>
    /// <param name="city">城市</param>
    /// <returns>地理编码结果</returns>
    Task<AmapGeoCode[]> GetGeoCodeAsync(string address, string city );

    /// <summary>
    /// 高德地图API - 搜索POI
    /// </summary>
    /// <param name="keywords">关键字</param>
    /// <param name="types">POI类型</param>
    /// <param name="region">城市</param>
    /// <param name="page">页码</param>
    /// <param name="offset">每页记录数</param>
    /// <returns>POI搜索结果</returns>
    Task<AmapPoi[]> SearchPOIAsync(string keywords, string types, string region, int page , int offset );

    /// <summary>
    /// 高德地图API - 逆地理编码（坐标转地址）
    /// </summary>
    /// <param name="location">经纬度坐标，格式：longitude,latitude</param>
    /// <returns>逆地理编码结果</returns>
    Task<AmapReGeoCode> GetReGeoCodeAsync(string location);

    /// <summary>
    /// 获取高德地图Web端配置
    /// </summary>
    /// <returns>Web端配置信息</returns>
    Task<AmapWebConfig> GetWebConfigAsync();
}
