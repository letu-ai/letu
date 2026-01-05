using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings.Dtos;

/// <summary>
/// 日志文件查询参数
/// </summary>
public class SystemLogListInput : PagedResultRequest
{
    /// <summary>
    /// 月份筛选（yyyy-MM格式）
    /// </summary>
    public string? Month { get; set; }
}

