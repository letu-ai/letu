namespace Letu.MobilePush;

/// <summary>
/// 推送结果
/// </summary>
public class PushResult
{
    /// <summary>
    /// 是否成功
    /// </summary>
    public bool Success { get; set; }

    /// <summary>
    /// 消息ID(推送成功时返回)
    /// </summary>
    public long? MessageId { get; set; }

    /// <summary>
    /// 请求ID(用于追踪)
    /// </summary>
    public required string RequestId { get; set; }

    /// <summary>
    /// 错误码(失败时返回)
    /// </summary>
    public string? ErrorCode { get; set; }

    /// <summary>
    /// 错误信息(失败时返回)
    /// </summary>
    public string? ErrorMessage { get; set; }
}
