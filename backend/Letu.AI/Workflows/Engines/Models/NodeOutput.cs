namespace Letu.AI.Workflows.Engines.Models;

/// <summary>
/// 节点活动输出基类
/// </summary>
public class NodeOutput
{
    /// <summary>
    /// 是否成功
    /// </summary>
    public bool Success { get; set; } = true;

    /// <summary>
    /// 错误消息
    /// </summary>
    public string? ErrorMessage { get; set; }
}

/// <summary>
/// 开始节点输出
/// </summary>
public class StartNodeOutput : NodeOutput
{
    /// <summary>
    /// 提取的文件内容（变量名 -> 内容）
    /// </summary>
    public Dictionary<string, string> FileContents { get; set; } = new();
}

/// <summary>
/// 文本分析节点输出
/// </summary>
public class TextAnalysisOutput : NodeOutput
{
    /// <summary>
    /// AI分析结果
    /// </summary>
    public string AnalysisResult { get; set; } = string.Empty;
}

/// <summary>
/// 用户输入节点输出
/// </summary>
public class UserInputOutput : NodeOutput
{
    /// <summary>
    /// 用户输入的内容
    /// </summary>
    public string UserInput { get; set; } = string.Empty;
}

/// <summary>
/// 文件选择节点输出
/// </summary>
public class FileSelectOutput : NodeOutput
{
    /// <summary>
    /// 选择的文件ID
    /// </summary>
    public string? FileId { get; set; }

    /// <summary>
    /// 文件内容（如果可用）
    /// </summary>
    public string? FileContent { get; set; }
}

