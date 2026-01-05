namespace Letu.Basis.Admin.Loggings.Dtos;

/// <summary>
/// 日志文件信息
/// </summary>
public class SystemLogListOutput
{
    /// <summary>
    /// 文件名
    /// </summary>
    public string FileName { get; set; } = null!;

    /// <summary>
    /// 文件路径（相对路径）
    /// </summary>
    public string FilePath { get; set; } = null!;

    /// <summary>
    /// 文件大小（字节）
    /// </summary>
    public long FileSize { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    public DateTime CreationTime { get; set; }

    /// <summary>
    /// 最后修改时间
    /// </summary>
    public DateTime LastWriteTime { get; set; }

    /// <summary>
    /// 是否已压缩
    /// </summary>
    public bool IsCompressed { get; set; }

    /// <summary>
    /// 所属月份（yyyy-MM格式）
    /// </summary>
    public string Month { get; set; } = null!;
}

