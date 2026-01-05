using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Users;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Roles;

/// <summary>
/// 角色表
/// </summary>
[Table(Name = "sys_role")]
public class Role : FullAuditedEntity<Guid>, IMultiTenant
{

    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true, StringLength = 18)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 角色名
    /// </summary>
    [NotNull]
    [StringLength(64)]
    [Column(IsNullable = false, StringLength = 64)]
    public required string Name { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    [StringLength(512)]
    [Column(StringLength = 512)]
    public string? Remark { get; set; }

    /// <summary>
    /// 新建用户默认分配的角色
    /// </summary>
    public virtual bool IsDefault { get; set; }

    /// <summary>
    /// 静态角色，系统内置不能删除和修改的角色
    /// </summary>
    public virtual bool IsStatic { get; set; }

    /// <summary>
    /// 用户可以查看其他用户的公共角色。一些特殊角色如“超级管理员”不允许被设置为公共角色。
    /// </summary>
    public virtual bool IsPublic { get; set; }


    [Navigate(ManyToMany = typeof(UserInRole))]
    public virtual ICollection<User>? Users { get; set; }

    /// <summary>
    /// 是否启用
    /// </summary>
    [Column(IsNullable = false)]
    public bool IsEnabled { get; set; } = false;
}