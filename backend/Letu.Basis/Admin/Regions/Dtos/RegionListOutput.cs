namespace Letu.Basis.Admin.Regions.Dtos;

public class RegionListOutput
{
    public int Id { get; set; }

    /// <summary>
    /// 父级行政区域代码
    /// </summary>
    public string? ParentCode { get; set; }

    /// <summary>
    /// 行政区域代码
    /// </summary>
    public required string Code { get; set; }

    /// <summary>
    /// 区域名称
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// 层级路径，如"110000/110100/110101"
    /// </summary>
    public string? Path { get; set; }

    /// <summary>
    /// 中心点坐标
    /// </summary>
    public string? Center { get; set; }

    /// <summary>
    /// 级别：1省/直辖市，2市/州，3县/区，4街道/乡镇
    /// </summary>
    public RegionLevel Level { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 下级类型：0=无下级（叶节点），1=省->市，2=市->区县，3=区县->街道，4=市->街道（跳过区县）
    /// </summary>
    public RegionLevel NextLevel { get; set; }
}