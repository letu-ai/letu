namespace Letu.AI.Workflows.Templates.Dtos;

/// <summary>
/// 工作流模板 DTO
/// </summary>
public class WorkflowTemplateOutput
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsPinned { get; set; }
    public string? FlowData { get; set; }
    public int Version { get; set; }
    public bool IsPublished { get; set; }
    public DateTime? LastPublishedTime { get; set; }
    public DateTime CreationTime { get; set; }
    public DateTime? LastModificationTime { get; set; }
}

