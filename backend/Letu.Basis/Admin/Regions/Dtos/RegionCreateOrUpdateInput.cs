using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Regions.Dtos;

public class RegionCreateOrUpdateInput
{
    /// <summary>
    /// 行政区域代码（如：110000北京市、110101东城区）
    /// </summary>
    [Required]
    [MaxLength(12)]
    public required string Code { get; set; }

    /// <summary>
    /// 区域名称
    /// </summary>
    [Required]
    [MaxLength(64)]
    public required string Name { get; set; }

    /// <summary>
    /// 中心点坐标
    /// </summary>
    [MaxLength(32)]
    public string? Center { get; set; }

    /// <summary>
    /// 父级ID
    /// </summary>
    public int? ParentId { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 是否启用
    /// </summary>
    public bool IsEnabled { get; set; } = true;
}