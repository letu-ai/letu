namespace Letu.AI.Workflows.Engines.Models;

/// <summary>
/// 节点活动输入基类
/// </summary>
public class NodeInput
{
    /// <summary>
    /// 节点ID
    /// </summary>
    public string NodeId { get; set; } = string.Empty;

    /// <summary>
    /// 节点类型
    /// </summary>
    public string NodeType { get; set; } = string.Empty;

    /// <summary>
    /// 工作流变量（用于变量替换）
    /// </summary>
    public Dictionary<string, object> Variables { get; set; } = new();
}

/// <summary>
/// 开始节点输入
/// </summary>
public class StartNodeInput : NodeInput
{
    /// <summary>
    /// 上传的文件路径（变量名 -> 文件路径）
    /// </summary>
    public Dictionary<string, string>? UploadedFilePaths { get; set; }

    /// <summary>
    /// 目录文件选择（变量名 -> 文件ID）
    /// </summary>
    public Dictionary<string, string>? DirectoryFileSelections { get; set; }
}

/// <summary>
/// 文本分析节点输入
/// </summary>
public class TextAnalysisInput : NodeInput
{
    /// <summary>
    /// 系统提示词
    /// </summary>
    public string SystemPrompt { get; set; } = string.Empty;

    /// <summary>
    /// 引用的输入变量名列表
    /// </summary>
    public List<string> InputVariables { get; set; } = new();

    /// <summary>
    /// AI模型名称
    /// </summary>
    public string? AiModel { get; set; }
}

/// <summary>
/// 用户输入节点输入
/// </summary>
public class UserInputInput : NodeInput
{
    /// <summary>
    /// 提示用户输入的文本
    /// </summary>
    public string? Prompt { get; set; }
}

/// <summary>
/// 文件选择节点输入
/// </summary>
public class FileSelectInput : NodeInput
{
    /// <summary>
    /// 工作模式：file | directory
    /// </summary>
    public string Mode { get; set; } = "file";

    /// <summary>
    /// 文件ID（mode='file'时使用）
    /// </summary>
    public string? FileId { get; set; }

    /// <summary>
    /// 目录ID（mode='directory'时使用）
    /// </summary>
    public string? DirectoryId { get; set; }

    /// <summary>
    /// 提示用户选择文件的文本
    /// </summary>
    public string? Prompt { get; set; }
}

