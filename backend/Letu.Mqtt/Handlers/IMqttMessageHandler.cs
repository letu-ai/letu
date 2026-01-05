using MQTTnet;

namespace Letu.Mqtt.Handlers;

/// <summary>
/// MQTT消息处理器接口
/// </summary>
public interface IMqttMessageHandler
{
    /// <summary>
    /// 判断是否能处理该主题的消息
    /// </summary>
    /// <param name="topic">主题</param>
    /// <returns>是否能处理</returns>
    bool CanHandle(string topic);

    /// <summary>
    /// 处理消息
    /// </summary>
    /// <param name="message">消息内容</param>
    Task HandleAsync(MqttApplicationMessage message, string? clientIp);

    /// <summary>
    /// 优先级,数字越小越优先
    /// </summary>
    int Priority { get; }
}
