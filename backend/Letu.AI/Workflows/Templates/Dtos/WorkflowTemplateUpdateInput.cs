namespace Letu.AI.Workflows.Templates.Dtos;

/// <summary>
/// 更新工作流模板请求
/// </summary>
public class WorkflowTemplateUpdateInput
{
    public string? Name { get; set; }
    public string? Description { get; set; }
    public bool? IsPinned { get; set; }
    public string? FlowData { get; set; }
}

