namespace Letu.Basis.UserSessions;

/// <summary>
/// 会话状态
/// </summary>
public enum SessionStatus
{
    /// <summary>
    /// 活跃
    /// </summary>
    Active,

    /// <summary>
    /// 非活跃
    /// </summary>
    Inactive,

    /// <summary>
    /// 已过期
    /// </summary>
    Expired,

    /// <summary>
    /// 被踢下线
    /// </summary>
    KickedOut
}
