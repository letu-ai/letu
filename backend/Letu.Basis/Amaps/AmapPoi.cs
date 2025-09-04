namespace Letu.Basis.Amaps;

/// <summary>
/// POI 兴趣点信息
/// </summary>
public class AmapPoi
{
    /// <summary>
    /// POI 名称
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// POI 唯一标识
    /// </summary>
    public required string Id { get; set; }

    /// <summary>
    /// POI 经纬度
    /// </summary>
    public required string Location { get; set; }

    /// <summary>
    /// POI 所属类型
    /// </summary>
    public required string Type { get; set; }

    /// <summary>
    /// POI 分类编码
    /// </summary>
    public required string TypeCode { get; set; }

    /// <summary>
    /// POI 所属省份
    /// </summary>
    public required string ProvinceName { get; set; }

    /// <summary>
    /// POI 所属城市
    /// </summary>
    public required string CityName { get; set; }

    /// <summary>
    /// POI 所属区县
    /// </summary>
    public required string DistrictName { get; set; }

    /// <summary>
    /// POI 详细地址
    /// </summary>
    public required string Address { get; set; }

    /// <summary>
    /// POI 所属省份编码
    /// </summary>
    public required string ProvinceCode { get; set; }

    /// <summary>
    /// POI 所属区域编码
    /// </summary>
    public required string AdCode { get; set; }

    /// <summary>
    /// POI 所属城市编码
    /// </summary>
    public required string CityCode { get; set; }
}
