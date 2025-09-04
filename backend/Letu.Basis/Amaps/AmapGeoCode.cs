using System.Text.Json.Serialization;

namespace Letu.Basis.Amaps;

/// <summary>
/// 地理编码
/// </summary>
public class AmapGeoCode
{
    /// <summary>
    /// 格式化地址
    /// </summary>
    [JsonPropertyName("formatted_address")]
    public required string FormatAddress { get; set; }

    /// <summary>
    /// 国家.国内地址默认返回中国
    /// </summary>
    public required string Country { get; set; }


    /// <summary>
    /// 地址所在的省份名
    /// </summary>
    public required string Province { get; set; }


    /// <summary>
    /// 地址所在的城市名
    /// </summary>
    public required string City { get; set; }

    /// <summary>
    /// 城市编码
    /// </summary>
    public required string CityCode { get; set; }

    /// <summary>
    /// 地址所在的区
    /// </summary>
    public required string District { get; set; }

    /// <summary>
    /// 街道
    /// </summary>
    public required string Street { get; set; }

    /// <summary>
    /// 门牌
    /// </summary>
    public required string Number { get; set; }

    /// <summary>
    /// 区域编码
    /// </summary>
    public required string AdCode { get; set; }

    /// <summary>
    /// 坐标点.经度，纬度
    /// </summary>
    public required string Location { get; set; }

    /// <summary>
    /// 匹配级别
    /// </summary>
    public required string Level { get; set; }
}
