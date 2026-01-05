namespace Letu.AI.Workflows.Templates.Dtos;

/// <summary>
/// 创建工作流模板请求
/// </summary>
public class WorkflowTemplateCreateInput
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string FlowData { get; set; } = string.Empty;
}

