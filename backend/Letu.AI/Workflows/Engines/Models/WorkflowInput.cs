namespace Letu.AI.Workflows.Engines.Models;

/// <summary>
/// 工作流启动输入参数
/// </summary>
public class WorkflowInput
{
    /// <summary>
    /// 工作流模板ID
    /// </summary>
    public Guid TemplateId { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// 执行标题
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 上传的文件路径（变量名 -> 文件路径）
    /// </summary>
    public Dictionary<string, string>? UploadedFilePaths { get; set; }

    /// <summary>
    /// 目录文件选择（变量名 -> 文件ID）
    /// </summary>
    public Dictionary<string, string>? DirectoryFileSelections { get; set; }

    /// <summary>
    /// 选择的AI模型
    /// </summary>
    public string? SelectedAiModel { get; set; }

    /// <summary>
    /// 工作流模板的 FlowData（React Flow JSON）
    /// </summary>
    public string FlowData { get; set; } = string.Empty;
}

