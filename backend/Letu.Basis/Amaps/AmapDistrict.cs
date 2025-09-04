using System.Text.Json.Serialization;
using Letu.Basis.Amaps.Converters;

namespace Letu.Basis.Amaps;

/// <summary>
/// 行政区域
/// </summary>
public class AmapDistrict
{
    /// <summary>
    /// 城市编码（高德API可能返回字符串或空数组）
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? CityCode { get; set; }

    /// <summary>
    /// 区域编码
    /// </summary>
    public string AdCode { get; set; } = string.Empty;

    /// <summary>
    /// 行政区名称
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// 行政区边界坐标点
    /// </summary>
    public string? Polyline { get; set; }

    /// <summary>
    /// 区域中心点
    /// 例如："117.020725,36.670201"
    /// </summary>
    public string Center { get; set; } = string.Empty;

    /// <summary>
    /// 行政区划级别
    /// country:国家
    /// province:省份（直辖市会在province显示）
    /// city:市（直辖市会在province显示）
    /// district:区县
    /// street:街道
    /// </summary>
    public string Level { get; set; } = string.Empty;

    /// <summary>
    /// 下级行政区列表，包含 district 元素
    /// </summary>
    public AmapDistrict[]? Districts { get; set; }
}
