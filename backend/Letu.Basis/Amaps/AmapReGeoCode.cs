using Letu.Basis.Amaps.Converters;
using System.Text.Json.Serialization;

namespace Letu.Basis.Amaps;

/// <summary>
/// 逆地理编码结果
/// </summary>
public class AmapReGeoCode
{
    /// <summary>
    /// 格式化地址
    /// </summary>
    [JsonPropertyName("formatted_address")]
    public string? FormattedAddress { get; set; }

    /// <summary>
    /// 地址组成元素
    /// </summary>
    [JsonPropertyName("addressComponent")]
    public AddressComponent? AddressComponent { get; set; }

    /// <summary>
    /// POI信息列表
    /// </summary>
    public AmapPoi[]? Pois { get; set; }

    /// <summary>
    /// 道路信息列表
    /// </summary>
    public Road[]? Roads { get; set; }

    /// <summary>
    /// 道路交叉口列表
    /// </summary>
    public Roadinter[]? Roadinters { get; set; }

    /// <summary>
    /// AOI信息列表
    /// </summary>
    public Aoi[]? Aois { get; set; }
}

/// <summary>
/// 地址组成元素
/// </summary>
public class AddressComponent
{
    /// <summary>
    /// 国家
    /// </summary>
    public string? Country { get; set; }

    /// <summary>
    /// 省份名称
    /// </summary>
    public string? Province { get; set; }

    /// <summary>
    /// 城市
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? City { get; set; }

    /// <summary>
    /// 城市编码
    /// </summary>
    [JsonPropertyName("citycode")]
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? CityCode { get; set; }

    /// <summary>
    /// 区县名称
    /// </summary>
    public string? District { get; set; }

    /// <summary>
    /// 区域编码
    /// </summary>
    [JsonPropertyName("adcode")]
    public string? AdCode { get; set; }

    /// <summary>
    /// 乡镇街道名称
    /// </summary>
    public string? Township { get; set; }

    /// <summary>
    /// 乡镇街道编码
    /// </summary>
    [JsonPropertyName("towncode")]
    public string? TownCode { get; set; }

    ///// <summary>
    ///// 社区名称
    ///// </summary>
    //public Neighborhood? Neighborhood { get; set; }

    ///// <summary>
    ///// 建筑名称
    ///// </summary>
    //[JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    //public Building? Building { get; set; }

    /// <summary>
    /// 门牌号
    /// </summary>
    [JsonPropertyName("streetNumber")]
    public StreetNumber? StreetNumber { get; set; }

    ///// <summary>
    ///// 商圈信息
    ///// </summary>
    //public BusinessArea[]? BusinessAreas { get; set; }
}

public class Neighborhood
{
    /// <summary>
    /// 社区名称
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? Name { get; set; }

    /// <summary>
    /// 社区类型
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? Type { get; set; }
}


public class Building
{
    /// <summary>
    /// 建筑名称
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? Name { get; set; }

    /// <summary>
    /// 建筑类型
    /// </summary>
    [JsonConverter(typeof(FlexibleStringOrArrayConverter))]
    public string? Type { get; set; }
}



/// <summary>
/// 门牌号信息
/// </summary>
public class StreetNumber
{
    /// <summary>
    /// 街道名称
    /// </summary>
    public string? Street { get; set; }

    /// <summary>
    /// 门牌号
    /// </summary>
    public string? Number { get; set; }

    /// <summary>
    /// 经纬度坐标
    /// </summary>
    public string? Location { get; set; }

    /// <summary>
    /// 方向
    /// </summary>
    public string? Direction { get; set; }

    /// <summary>
    /// 距离（米）
    /// </summary>
    public string? Distance { get; set; }
}

/// <summary>
/// 道路信息
/// </summary>
public class Road
{
    /// <summary>
    /// 道路ID
    /// </summary>
    public string? Id { get; set; }

    /// <summary>
    /// 道路名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 道路到查询点的距离（米）
    /// </summary>
    public string? Distance { get; set; }

    /// <summary>
    /// 方位
    /// </summary>
    public string? Direction { get; set; }

    /// <summary>
    /// 道路经纬度
    /// </summary>
    public string? Location { get; set; }
}

/// <summary>
/// 道路交叉口
/// </summary>
public class Roadinter
{
    /// <summary>
    /// 交叉路口到查询点的距离（米）
    /// </summary>
    public string? Distance { get; set; }

    /// <summary>
    /// 方位
    /// </summary>
    public string? Direction { get; set; }

    /// <summary>
    /// 路口经纬度
    /// </summary>
    public string? Location { get; set; }

    /// <summary>
    /// 第一条道路ID
    /// </summary>
    [JsonPropertyName("first_id")]
    public string? FirstId { get; set; }

    /// <summary>
    /// 第一条道路名称
    /// </summary>
    [JsonPropertyName("first_name")]
    public string? FirstName { get; set; }

    /// <summary>
    /// 第二条道路ID
    /// </summary>
    [JsonPropertyName("second_id")]
    public string? SecondId { get; set; }

    /// <summary>
    /// 第二条道路名称
    /// </summary>
    [JsonPropertyName("second_name")]
    public string? SecondName { get; set; }
}

/// <summary>
/// AOI信息（面状地理实体）
/// </summary>
public class Aoi
{
    /// <summary>
    /// AOI的ID
    /// </summary>
    public string? Id { get; set; }

    /// <summary>
    /// AOI名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// AOI所在区域编码
    /// </summary>
    [JsonPropertyName("adcode")]
    public string? AdCode { get; set; }

    /// <summary>
    /// AOI中心点坐标
    /// </summary>
    public string? Location { get; set; }

    /// <summary>
    /// AOI的面积（平方米）
    /// </summary>
    public string? Area { get; set; }

    /// <summary>
    /// 距离（米）
    /// </summary>
    public string? Distance { get; set; }

    /// <summary>
    /// AOI类型
    /// </summary>
    public string? Type { get; set; }
}

/// <summary>
/// 商圈信息
/// </summary>
public class BusinessArea
{
    /// <summary>
    /// 商圈所在区域编码
    /// </summary>
    public string? Location { get; set; }

    /// <summary>
    /// 商圈名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 商圈ID
    /// </summary>
    public string? Id { get; set; }
}

/// <summary>
/// 逆地理编码响应
/// </summary>
public class AmapReGeoCodeResponse
{
    /// <summary>
    /// 返回状态，1：成功；0：失败
    /// </summary>
    public string? Status { get; set; }

    /// <summary>
    /// 返回状态说明
    /// </summary>
    public string? Info { get; set; }

    /// <summary>
    /// 返回状态码
    /// </summary>
    [JsonPropertyName("infocode")]
    public string? InfoCode { get; set; }

    /// <summary>
    /// 逆地理编码信息
    /// </summary>
    [JsonPropertyName("regeocode")]
    public AmapReGeoCode? ReGeocode { get; set; }
}