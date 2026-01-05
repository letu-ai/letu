using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;
using MQTTnet;
using MQTTnet.Protocol;
using MQTTnet.Server;
using Volo.Abp.DependencyInjection;

namespace Letu.Mqtt.Services;

/// <summary>
/// MQTT消息发布服务实现
/// </summary>
public class MqttPublishService : IMqttPublishService, ISingletonDependency
{
    private readonly MqttServer mqttServer;
    private readonly ILogger<MqttPublishService> logger;

    public MqttPublishService(MqttServer mqttServer, ILogger<MqttPublishService> logger)
    {
        this.mqttServer = mqttServer;
        this.logger = logger;
    }

    public async Task PublishAsync(
        string topic,
        byte[] payload,
        MqttQualityOfServiceLevel qos = MqttQualityOfServiceLevel.AtMostOnce,
        bool retain = false)
    {
        try
        {
            var message = new MqttApplicationMessageBuilder()
                .WithTopic(topic)
                .WithPayload(payload)
                .WithQualityOfServiceLevel(qos)
                .WithRetainFlag(retain)
                .Build();

            await mqttServer.InjectApplicationMessage(
                new InjectedMqttApplicationMessage(message)
                {
                    SenderClientId = "Server"
                });

        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to publish message to topic: {Topic}", topic);
            throw;
        }
    }

    public async Task PublishJsonAsync<T>(
        string topic,
        T data,
        MqttQualityOfServiceLevel qos = MqttQualityOfServiceLevel.AtMostOnce,
        bool retain = false)
    {
        var json = JsonSerializer.Serialize(data);
        var payload = Encoding.UTF8.GetBytes(json);

        await PublishAsync(topic, payload, qos, retain);
    }
}
