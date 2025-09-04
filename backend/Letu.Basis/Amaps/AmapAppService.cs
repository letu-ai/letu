using Microsoft.Extensions.Logging;
using System.Web;
using Letu.Basis.Settings;
using Letu.Basis.Amaps.Converters;
using Volo.Abp;
using Polly;
using Polly.Extensions.Http;
using System.Text.Json;

namespace Letu.Basis.Amaps;

public class AmapAppService : BasisAppService, IAmapAppService
{
    private readonly IHttpClientFactory httpClientFactory;
    private readonly ILogger<AmapAppService> logger;
    
    // 静态的 JsonSerializerOptions，避免重复创建
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new FlexibleStringOrArrayConverter() }
    };

    // Polly重试策略：针对QPS限流错误
    private readonly IAsyncPolicy<string> retryPolicy;
    
    public AmapAppService(
        IHttpClientFactory httpClientFactory,
        ILogger<AmapAppService> logger)
    {
        this.httpClientFactory = httpClientFactory;
        this.logger = logger;

        // 初始化Polly重试策略
        retryPolicy = Policy
            .HandleResult<string>(response => IsRateLimitError(response))
            .WaitAndRetryAsync(
                retryCount: 3,
                sleepDurationProvider: retryAttempt => TimeSpan.FromMilliseconds(500 * Math.Pow(2, retryAttempt - 1)) + 
                                                      TimeSpan.FromMilliseconds(Random.Shared.Next(0, 100)), // 添加抖动
                onRetry: (outcome, timespan, retryCount, context) =>
                {
                    logger.LogWarning("高德API调用遇到限流，第 {retryCount} 次重试，延迟 {delay}ms", 
                        retryCount, timespan.TotalMilliseconds);
                });
    }

    /// <summary>
    /// 检测是否为限流错误
    /// </summary>
    /// <param name="responseContent">API响应内容</param>
    /// <returns>是否为限流错误</returns>
    private static bool IsRateLimitError(string responseContent)
    {
        if (string.IsNullOrEmpty(responseContent))
            return false;

        try
        {
            var response = JsonSerializer.Deserialize<AmapDistrictResponse>(responseContent, JsonOptions);
            return response != null && 
                   (response.Info?.Contains("CUQPS_HAS_EXCEEDED_THE_LIMIT") == true ||
                    response.Info?.Contains("QPS_HAS_EXCEEDED_THE_LIMIT") == true ||
                    response.Status == "0" && response.Info?.Contains("LIMIT") == true);
        }
        catch
        {
            return false;
        }
    }

    /// <summary>
    /// 获取所有省份
    /// </summary>
    /// <returns>省份列表</returns>
    public async Task<AmapDistrict[]> GetAllProvincesAsync()
    {
        var apiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey)
            ?? throw new UserFriendlyException("高德地图API密钥未配置");

        var client = httpClientFactory.CreateClient("amap");
        var url = $"/v3/config/district?key={apiKey}&keywords=100000&subdistrict=1&extensions=base";
        
        logger.LogInformation("正在调用高德API获取全国省份数据，URL: {url}", url);
        
        try
        {
            // 使用Polly重试策略获取数据
            var responseString = await retryPolicy.ExecuteAsync(async () =>
            {
                logger.LogDebug("调用高德API获取全国省份数据");
                return await client.GetStringAsync(url);
            });
            logger.LogDebug("高德API原始响应: {response}", responseString);
            
            // 尝试反序列化
            var response = JsonSerializer.Deserialize<AmapDistrictResponse>(responseString, JsonOptions);
            
            if (response == null)
            {
                logger.LogError("反序列化高德API响应失败，响应内容: {response}", responseString);
                throw new UserFriendlyException("解析高德地图数据失败");
            }
            
            if (response.Status != "1" || response.InfoCode != "10000")
            {
                logger.LogError("高德API返回错误，Status: {status}, Info: {info}, InfoCode: {infoCode}", 
                    response.Status, response.Info, response.InfoCode);
                throw new UserFriendlyException($"高德地图API错误: {response.Info}");
            }
            
            if (response.Districts == null || response.Districts.Length == 0)
            {
                logger.LogError("高德API返回的Districts为空");
                return [];
            }
            
            logger.LogInformation("成功获取到 {count} 个顶级行政区域", response.Districts.Length);
            
            if (response.Districts[0].Districts == null || response.Districts[0].Districts.Length == 0)
            {
                logger.LogWarning("全国节点下没有省份数据");
                return [];
            }
            
            logger.LogInformation("成功获取到 {count} 个省份", response.Districts[0].Districts.Length);
            
            // 记录每个省份的信息
            foreach (var province in response.Districts[0].Districts)
            {
                logger.LogDebug("省份: {name}, AdCode: {adCode}, Level: {level}", 
                    province.Name, province.AdCode, province.Level);
            }
            
            return response.Districts[0].Districts;
        }
        catch (HttpRequestException ex)
        {
            logger.LogError(ex, "调用高德API失败");
            throw new UserFriendlyException("调用高德地图服务失败，请检查网络连接");
        }
        catch (JsonException ex)
        {
            logger.LogError(ex, "解析高德API响应JSON失败");
            throw new UserFriendlyException("解析高德地图数据格式错误");
        }
    }

    /// <summary>
    /// 获取行政区域
    /// </summary>
    /// <param name="adCode"></param>
    /// <returns></returns>
    public async Task<AmapDistrict[]> GetDistrictAsync(string adCode)
    {
        var apiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey)
            ?? throw new UserFriendlyException("高德地图API密钥未配置");

        var client = httpClientFactory.CreateClient("amap");
        var url = $"/v3/config/district?&key={apiKey}&keywords={HttpUtility.UrlEncode(adCode)}&subdistrict=1&extensions=base";

        logger.LogInformation("正在获取行政区域 {adCode} 的子级数据", adCode);
        
        try
        {
            // 使用Polly重试策略获取数据
            var responseString = await retryPolicy.ExecuteAsync(async () =>
            {
                logger.LogDebug("调用高德API获取行政区域 {adCode}", adCode);
                return await client.GetStringAsync(url);
            });
            logger.LogDebug("行政区域 {adCode} 的API响应: {response}", adCode, responseString);
            
            var response = JsonSerializer.Deserialize<AmapDistrictResponse>(responseString, JsonOptions);
            
            if (response == null)
            {
                logger.LogError("反序列化行政区域 {adCode} 响应失败", adCode);
                return [];
            }
            
            if (response.Status != "1" || response.InfoCode != "10000")
            {
                logger.LogError("获取行政区域 {adCode} 失败，Status: {status}, Info: {info}", 
                    adCode, response.Status, response.Info);
                return [];
            }
            
            if (response.Districts == null || response.Districts.Length == 0)
            {
                logger.LogWarning("行政区域 {adCode} 没有返回数据", adCode);
                return [];
            }
            
            if (response.Districts.Length > 0 && response.Districts[0].Districts != null)
            {
                logger.LogInformation("行政区域 {adCode} 获取到 {count} 个子级区域", 
                    adCode, response.Districts[0].Districts.Length);
            }
            else
            {
                logger.LogInformation("行政区域 {adCode} 没有子级区域", adCode);
            }
            
            return response.Districts;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "获取行政区域 {adCode} 失败", adCode);
            return [];
        }
    }

    public async Task<AmapGeoCode[]> GetGeoCodeAsync(string address, string city = "")
    {
        var apiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey)
            ?? throw new UserFriendlyException("高德地图API密钥未配置");

        var client = httpClientFactory.CreateClient("amap");
        var url = $"/v3/geocode/geo?key={apiKey}&address={HttpUtility.UrlEncode(address)}";

        if (!string.IsNullOrEmpty(city))
        {
            url += $"&city={HttpUtility.UrlEncode(city)}";
        }

        var response = await client.GetFromJsonAsync<AmapGeoCodeResponse>(url);
        if (response == null)
        {
            logger.LogError("获取地理编码失败: {address}", address);
            return [];
        }
        return response.GeoCodes;
    }

    public async Task<AmapPoi[]> SearchPOIAsync(
        string keywords,
        string types = "",
        string region = "",
        int page = 1,
        int offset = 20)
    {
        var apiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey)
            ?? throw new UserFriendlyException("高德地图API密钥未配置");

        var client = httpClientFactory.CreateClient("amap");
        var url = $"/v5/place/text?key={apiKey}&keywords={HttpUtility.UrlEncode(keywords)}&page={page}&offset={offset}";

        if (!string.IsNullOrEmpty(types))
        {
            url += $"&types={HttpUtility.UrlEncode(types)}";
        }

        if (!string.IsNullOrEmpty(region))
        {
            url += $"&region={HttpUtility.UrlEncode(region)}";
        }

        var response = await client.GetFromJsonAsync<AmapPoiResponse>(url);
        if (response == null)
        {
            logger.LogError("获取POI失败: {keywords}", keywords);
            return [];
        }

        return response.Pois;
    }
}