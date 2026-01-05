using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.UserSessions.Dtos;

/// <summary>
/// 用户会话更新输入参数
/// </summary>
public class UserSessionUpdateInput
{
    /// <summary>
    /// 最后活跃时间
    /// </summary>
    public DateTime? LastActiveTime { get; set; }

    /// <summary>
    /// 过期时间
    /// </summary>
    public DateTime? ExpireTime { get; set; }

    /// <summary>
    /// 会话状态
    /// </summary>
    public SessionStatus? Status { get; set; }

    /// <summary>
    /// 刷新令牌
    /// </summary>
    [StringLength(512)]
    public string? RefreshToken { get; set; }
}
