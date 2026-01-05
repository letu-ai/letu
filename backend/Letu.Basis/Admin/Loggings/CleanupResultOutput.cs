namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 清理结果
/// </summary>
public class CleanupResultOutput
{
    /// <summary>
    /// 压缩的文件数量
    /// </summary>
    public int CompressedCount { get; set; }

    /// <summary>
    /// 删除的文件数量
    /// </summary>
    public int DeletedCount { get; set; }
}

