using MQTTnet.Protocol;

namespace Letu.Mqtt.Services;

/// <summary>
/// MQTT消息发布服务接口
/// </summary>
public interface IMqttPublishService
{
    /// <summary>
    /// 发布二进制消息
    /// </summary>
    /// <param name="topic">主题</param>
    /// <param name="payload">消息内容</param>
    /// <param name="qos">服务质量等级</param>
    /// <param name="retain">是否保留消息</param>
    Task PublishAsync(
        string topic,
        byte[] payload,
        MqttQualityOfServiceLevel qos = MqttQualityOfServiceLevel.AtMostOnce,
        bool retain = false);

    /// <summary>
    /// 发布JSON对象消息
    /// </summary>
    /// <typeparam name="T">消息对象类型</typeparam>
    /// <param name="topic">主题</param>
    /// <param name="data">消息对象</param>
    /// <param name="qos">服务质量等级</param>
    /// <param name="retain">是否保留消息</param>
    Task PublishJsonAsync<T>(
        string topic,
        T data,
        MqttQualityOfServiceLevel qos = MqttQualityOfServiceLevel.AtMostOnce,
        bool retain = false);
}
