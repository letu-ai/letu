namespace Letu.Basis.Admin.Loggings.Dtos;

/// <summary>
/// 日志文件内容（分页）
/// </summary>
public class SystemLogContentOutput
{
    /// <summary>
    /// 日志行列表
    /// </summary>
    public List<string> Lines { get; set; } = new();

    /// <summary>
    /// 总行数
    /// </summary>
    public long TotalLines { get; set; }

    /// <summary>
    /// 当前跳过的行数
    /// </summary>
    public int Skip { get; set; }

    /// <summary>
    /// 当前获取的行数
    /// </summary>
    public int Take { get; set; }

    /// <summary>
    /// 是否还有更多数据
    /// </summary>
    public bool HasMore { get; set; }
}

