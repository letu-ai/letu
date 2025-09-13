using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;

namespace Letu.Basis.Admin.Regions;

/// <summary>
/// 街道表
/// </summary>
[Table(Name = "sys_region_street")]
[Index("idx_region_street_region_code", nameof(RegionCode))]
public class Street : AuditedEntity<int>
{
    [Column(IsPrimary = true, IsIdentity = true)]
    public override int Id { get; protected set; }

    /// <summary>
    /// 高德地图区域代码（可能与父级相同）
    /// </summary>
    [Column(IsNullable = false, StringLength = 12)]
    public required string RegionCode { get; set; }

    /// <summary>
    /// 街道名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 64)]
    public required string Name { get; set; }

    /// <summary>
    /// 中心点坐标
    /// </summary>
    [Column(StringLength = 32)]
    public string? Center { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }
}