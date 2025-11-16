using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.OrganizationUnits;

/// <summary>
/// 组织机构单元表
/// </summary>
[Table(Name = "sys_organization_unit")]
public class OrganizationUnit : FullAuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 父ID
    /// </summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 组织机构单元编号
    /// </summary>
    [Required]
    [StringLength(32)]
    [Column(IsNullable = false, StringLength = 32)]
    public required string Code { get; set; }

    /// <summary>
    /// 组织机构单元名称
    /// </summary>
    [Required]
    [StringLength(64)]
    [Column(IsNullable = false, StringLength = 64)]
    public required string Name { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 机构种类（大类）
    /// </summary>
    [Column(IsNullable = false, StringLength = 64)]
    public string Category { get; set; } = "0"; // 默认值为 0，表示默认种类

    /// <summary>
    /// 机构类型（小类）
    /// </summary>
    [Column(IsNullable = true, StringLength = 64)]
    public string? Type { get; set; }

    /// <summary>
    /// 所属行政区域（关联 Region.Code）
    /// </summary>
    [Column(IsNullable = true, StringLength = 12)]
    public string? RegionCode { get; set; }

    /// <summary>
    /// 行政区域街道名称
    /// </summary>
    [Column(IsNullable = true, StringLength = 64)]
    public string? StreetName { get; set; }

    /// <summary>
    /// 地址
    /// </summary>
    [Column(IsNullable = true, StringLength = 256)]
    public string? Address { get; set; }

    /// <summary>
    /// 联系人
    /// </summary>
    [Column(IsNullable = true, StringLength = 64)]
    public string? ContactPerson { get; set; }

    /// <summary>
    /// 联系电话
    /// </summary>
    [Column(IsNullable = true, StringLength = 64)]
    public string? ContactPhone { get; set; }

    /// <summary>
    /// 经度
    /// </summary>
    [Column(IsNullable = true, Precision = 18, Scale = 6)]
    public decimal? Longitude { get; set; }

    /// <summary>
    /// 纬度
    /// </summary>
    [Column(IsNullable = true, Precision = 18, Scale = 6)]
    public decimal? Latitude { get; set; }

}