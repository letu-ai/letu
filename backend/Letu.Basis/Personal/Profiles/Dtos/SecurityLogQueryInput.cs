using Letu.Core.Applications;

namespace Letu.Basis.Personal.Profiles.Dtos;

public class SecurityLogQueryInput : PagedResultRequest
{
    /// <summary>
    /// 开始日期
    /// </summary>
    public DateTime? StartDate { get; set; }

    /// <summary>
    /// 结束日期
    /// </summary>
    public DateTime? EndDate { get; set; }

    /// <summary>
    /// 登录状态
    /// </summary>
    public bool? IsSuccess { get; set; }

    /// <summary>
    /// IP地址
    /// </summary>
    public string? Ip { get; set; }
}