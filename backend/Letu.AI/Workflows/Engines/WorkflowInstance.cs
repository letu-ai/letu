using FreeSql.DataAnnotations;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.AI.Workflows.Engines;

/// <summary>
/// 工作流实例实体
/// 存储工作流执行的元数据和状态
/// </summary>
[Table(Name = "ai_workflow_instance")]
public class WorkflowInstance : AuditedEntity<string>, IMultiTenant
{
    /// <summary>
    /// 实例ID（Durable Task 实例ID，主键）
    /// </summary>
    [Column(IsPrimary = true, StringLength = 256)]
    public new string Id { get; set; } = string.Empty;
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 工作流模板ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid TemplateId { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    /// <summary>
    /// 执行标题
    /// </summary>
    [Column(StringLength = 256)]
    public string? Title { get; set; }

    /// <summary>
    /// 执行状态
    /// </summary>
    [Column(IsNullable = false)]
    public ExecutionStatusDto Status { get; set; }

    /// <summary>
    /// 当前执行的节点ID
    /// </summary>
    [Column(StringLength = 256)]
    public string? CurrentNodeId { get; set; }

    /// <summary>
    /// 工作流变量（JSON格式）
    /// </summary>
    [Column(DbType = "jsonb")]
    public string? Variables { get; set; }

    /// <summary>
    /// 选择的AI模型
    /// </summary>
    [Column(StringLength = 256)]
    public string? SelectedAiModel { get; set; }

    /// <summary>
    /// 完成时间
    /// </summary>
    [Column(IsNullable = true)]
    public DateTime? CompletedAt { get; set; }
}

