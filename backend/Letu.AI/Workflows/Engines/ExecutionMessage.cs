using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.AI.WorkflowTemplates.WorkflowEngines.Entities;

/// <summary>
/// 执行消息记录
/// 存储工作流执行过程中的消息（用户输入、AI 输出等）
/// </summary>
[Table(Name = "ai_execution_message")]
public class ExecutionMessage : CreationAuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 消息角色：user | assistant | system
    /// </summary>
    [Column(IsNullable = false, StringLength = 32)]
    public required string Role { get; set; }

    /// <summary>
    /// 消息内容
    /// </summary>
    [Column(DbType = "text")]
    public required string Content { get; set; }

    /// <summary>
    /// 工作流实例ID（Durable Task 实例ID）
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string InstanceId { get; set; }

    /// <summary>
    /// 关联的节点ID（对应 React Flow 中的节点ID）
    /// </summary>
    [Column(StringLength = 256)]
    public string? NodeId { get; set; }
}

