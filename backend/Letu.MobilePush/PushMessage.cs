namespace Letu.MobilePush;

/// <summary>
/// 推送消息模型
/// </summary>
public class PushMessage
{
    /// <summary>
    /// 消息标题
    /// </summary>
    public required string Title { get; set; }

    /// <summary>
    /// 消息内容
    /// </summary>
    public required string Body { get; set; }
}
