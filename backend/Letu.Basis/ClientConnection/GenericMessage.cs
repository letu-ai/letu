namespace Letu.Basis.ClientConnection;

/// <summary>
/// 通用消息基类
/// </summary>
public abstract class GenericMessage
{
    /// <summary>
    /// 消息类型
    /// </summary>
    public string Type { get; set; } = string.Empty;
    
    /// <summary>
    /// 消息时间戳
    /// </summary>
    public DateTime Timestamp { get; set; } = DateTime.Now;
}

/// <summary>
/// 泛型通用消息
/// </summary>
/// <typeparam name="T">负载类型</typeparam>
public class GenericMessage<T> : GenericMessage
{
    public GenericMessage() { }

    public GenericMessage(string type, T payload)
    {
        Type = type;
        Payload = payload;
    }

    /// <summary>
    /// 消息负载
    /// </summary>
    public T? Payload { get; set; } = default!;
}