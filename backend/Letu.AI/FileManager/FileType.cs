using System.Text.Json.Serialization;

namespace Letu.AI.FileManager;

/// <summary>
/// 文件类型枚举
/// </summary>
[JsonConverter(typeof(JsonStringEnumConverter))]
public enum FileType
{
    /// <summary>
    /// 图片
    /// </summary>
    Image = 0,

    /// <summary>
    /// Excel文件
    /// </summary>
    Excel = 1,

    /// <summary>
    /// Word文件
    /// </summary>
    Word = 2,

    /// <summary>
    /// PDF文件
    /// </summary>
    Pdf = 3,

    /// <summary>  
    /// 视频文件
    /// </summary>
    Video = 4,

    /// <summary>
    /// 文本文件
    /// </summary>
    Text = 5,

    /// <summary>
    /// 其他类型
    /// </summary>
    Other = 6,
}

