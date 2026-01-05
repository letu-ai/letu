namespace Letu.AI.Workflows.Engines.Models;

/// <summary>
/// 工作流执行状态
/// </summary>
public class WorkflowState
{
    /// <summary>
    /// 当前执行的节点ID
    /// </summary>
    public string? CurrentNodeId { get; set; }

    /// <summary>
    /// 工作流变量字典
    /// </summary>
    public Dictionary<string, object> Variables { get; set; } = new();

    /// <summary>
    /// 执行状态
    /// </summary>
    public string Status { get; set; } = "Running";
}

