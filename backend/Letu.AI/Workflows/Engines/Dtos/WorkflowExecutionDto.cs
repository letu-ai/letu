namespace Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;

/// <summary>
/// 工作流执行状态
/// </summary>
public enum ExecutionStatusDto
{
    Running = 0,
    WaitingInput = 1,
    WaitingFileSelect = 2,
    Completed = 3,
    Failed = 4
}

/// <summary>
/// 工作流执行 DTO
/// </summary>
public class WorkflowExecutionDto
{
    public Guid TemplateId { get; set; }
    public string TemplateName { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public ExecutionStatusDto Status { get; set; }
    public string? CurrentNodeId { get; set; }
    public Dictionary<string, object>? Variables { get; set; }
    public string? PdfFileName { get; set; }
    public string? PdfFilePath { get; set; }
    public string? SelectedEquipmentFile { get; set; }
    public string? SelectedQualificationFile { get; set; }
    public string? SelectedAiModel { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
}

/// <summary>
/// 开始执行工作流请求
/// </summary>
public class StartExecutionInput
{
    public Guid TemplateId { get; set; }
    public string? Title { get; set; }
    public Dictionary<string, string>? UploadedFilePaths { get; set; } // 变量名 -> 文件路径
    public Dictionary<string, string>? DirectoryFileSelections { get; set; } // 变量名 -> 文件ID
    public string? SelectedAiModel { get; set; }
}

/// <summary>
/// 继续执行工作流请求
/// </summary>
public class ContinueExecutionInput
{
    public string? UserInput { get; set; } // 用户输入文本（用户输入节点使用）
    public string? FileId { get; set; } // 选择的文件ID（文件选择节点使用）
}

/// <summary>
/// 执行消息 DTO
/// </summary>
public class ExecutionMessageDto
{
    public Guid Id { get; set; }
    public string InstanceId { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty; // user | assistant | system
    public string Content { get; set; } = string.Empty;
    public string? NodeId { get; set; }
    public DateTime CreatedAt { get; set; }
}

