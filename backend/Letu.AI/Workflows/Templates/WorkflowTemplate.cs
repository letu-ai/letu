using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Users;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.AI.Workflows.Templates;

/// <summary>
/// 工作流模板实体
/// </summary>
[Table(Name = "ai_workflow_template")]
public class WorkflowTemplate : AuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    /// <summary>
    /// 用户
    /// </summary>
    [Navigate(nameof(UserId))]
    public User? User { get; set; }

    /// <summary>
    /// 流程名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string Name { get; set; }

    /// <summary>
    /// 流程描述
    /// </summary>
    [Column(StringLength = 1024)]
    public string? Description { get; set; }

    /// <summary>
    /// 是固定排前显示的流程。
    /// </summary>
    [Column(IsNullable = false)]
    public bool IsPinned { get; set; }

    /// <summary>
    /// React Flow 数据（节点、边、位置等）
    /// 用于前端设计器显示
    /// </summary>
    [Column(DbType = "jsonb")]
    public string? FlowData { get; set; }

    /// <summary>
    /// 当前版本号（每次发布递增）
    /// </summary>
    [Column(IsNullable = false)]
    public int Version { get; set; } = 1;

    /// <summary>
    /// 是否已发布
    /// </summary>
    [Column(IsNullable = false)]
    public bool IsPublished { get; set; }

    /// <summary>
    /// 最后发布时间
    /// </summary>
    [Column(IsNullable = true)]
    public DateTime? LastPublishedTime { get; set; }
}

