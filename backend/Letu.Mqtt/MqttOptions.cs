namespace Letu.Mqtt;

/// <summary>
/// MQTT服务器配置选项
/// </summary>
public class MqttOptions
{
    /// <summary>
    /// 是否启用MQTT服务器
    /// </summary>
    public bool IsEnabled { get; set; }

    /// <summary>
    /// MQTT端口
    /// </summary>
    public int Port { get; set; } = 1883;

    /// <summary>
    /// 用户名(可选)
    /// </summary>
    public string? Username { get; set; }

    /// <summary>
    /// 密码(可选)
    /// </summary>
    public string? Password { get; set; }

    /// <summary>
    /// 每个客户端最大挂起消息数
    /// </summary>
    public int MaxPendingMessagesPerClient { get; set; } = 250;
}
