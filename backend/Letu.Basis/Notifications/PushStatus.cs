namespace Letu.Basis.Notifications;

/// <summary>
/// 推送状态
/// </summary>
public enum PushStatus
{
    /// <summary>
    /// 待推送
    /// </summary>
    Pending = 0,

    /// <summary>
    /// 推送成功
    /// </summary>
    Success = 1,

    /// <summary>
    /// 推送失败（等待重试）
    /// </summary>
    Failed = 2,

    /// <summary>
    /// 跳过（无目标设备等）
    /// </summary>
    Skipped = 3,

    /// <summary>
    /// 过期（超过有效期或最大重试次数）
    /// </summary>
    Expired = 4
}
