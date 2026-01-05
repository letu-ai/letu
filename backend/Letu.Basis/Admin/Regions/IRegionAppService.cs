using Letu.Basis.Admin.Regions.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Regions;

public interface IRegionAppService
{

    /// <summary>
    /// 从高德地图API导入行政区域数据
    /// </summary>
    /// <param name="includeStreets">是否导入街道数据</param>
    /// <returns></returns>
    Task<RegionImportResultDto> ImportFromAmapAsync(bool includeStreets);

    /// <summary>
    /// 获取导入进度
    /// </summary>
    /// <returns></returns>
    Task<RegionImportProgressDto> GetImportProgressAsync();

    /// <summary>
    /// 根据代码获取区域信息
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    Task<RegionListOutput> GetRegionByCodeAsync(string code);

    /// <summary>
    /// 根据父级代码获取子级区域
    /// </summary>
    /// <param name="parentCode">父级区域代码，null表示获取顶级</param>
    /// <returns></returns>
    Task<List<RegionListOutput>> GetChildrenByCodeAsync(string? parentCode);

    /// <summary>
    /// 根据代码获取区域的完整路径
    /// </summary>
    /// <param name="code">区域代码</param>
    /// <returns>从顶级到当前区域的完整路径</returns>
    Task<List<RegionListOutput>> GetPathByCodeAsync(string code);

    /// <summary>
    /// 获取区域的省市区信息
    /// </summary>
    /// <param name="regionCode">区域代码</param>
    /// <returns>省市区信息</returns>
    Task<RegionInfo> GetRegionInfoAsync(string regionCode);

    /// <summary>
    /// 批量获取区域的省市区信息
    /// </summary>
    /// <param name="regionCodes">区域代码列表</param>
    /// <returns>区域代码与省市区信息的字典</returns>
    Task<Dictionary<string, RegionInfo>> GetRegionInfoBatchAsync(List<string> regionCodes);

    /// <summary>
    /// 根据行政区域代码判断其级别
    /// </summary>
    /// <param name="code">行政区域代码</param>
    /// <returns>区域级别</returns>
    RegionLevel GetCodeLevel(string? code);
}