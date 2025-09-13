namespace Letu.Basis.Admin.Regions.Dtos;

public class StreetListOutput
{
    public int Id { get; set; }

    /// <summary>
    /// 高德地图区域代码
    /// </summary>
    public required string RegionCode { get; set; }

    /// <summary>
    /// 街道名称
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// 中心点坐标
    /// </summary>
    public string? Center { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }
}