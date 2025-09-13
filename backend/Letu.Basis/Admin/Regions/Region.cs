using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;

namespace Letu.Basis.Admin.Regions;

/// <summary>
/// 行政区域表
/// </summary>
[Table(Name = "sys_region")]
[Index("idx_region_path", nameof(Path))]
[Index("idx_region_code", nameof(Code), IsUnique = true)]
public class Region : AuditedEntity<int>
{
    [Column(IsPrimary = true, IsIdentity = true)]
    public override int Id { get; protected set; }

    /// <summary>
    /// 父级ID
    /// </summary>
    [Column(StringLength = 12)]
    public string? ParentCode { get; set; }

    /// <summary>
    /// 行政区域代码（如：110000北京市、110101东城区）
    /// </summary>
    [Column(IsNullable = false, StringLength = 12)]
    public required string Code { get; set; }

    /// <summary>
    /// 区域名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 64)]
    public required string Name { get; set; }

    /// <summary>
    /// 层级路径，如"110000/110100/110101"
    /// 用于高效的层级查询
    /// </summary>
    [Column(StringLength = 100)]
    public string? Path { get; set; }

    /// <summary>
    /// 中心点坐标
    /// </summary>
    [Column(StringLength = 32)]
    public string? Center { get; set; }

    /// <summary>
    /// 级别：1省/直辖市，2市/州，3县/区，4街道/乡镇
    /// </summary>
    [Column(IsNullable = false)]
    public RegionLevel Level { get; set; }

    /// <summary>
    /// 下级类型
    /// 因为部分城市和省直辖县没有区县的级别，故市级的下一级就是街道。
    /// 例如：广东-东莞、海南-文昌市
    /// </summary>
    [Column(IsNullable = false)]
    public RegionLevel NextLevel { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }
}