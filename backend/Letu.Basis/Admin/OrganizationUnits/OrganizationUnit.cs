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

}