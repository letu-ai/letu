using Microsoft.Extensions.Logging;
using MQTTnet.Server;
using Volo.Abp.DependencyInjection;

namespace Letu.Mqtt.Handlers;

/// <summary>
/// MQTT消息分发器
/// </summary>
public class MqttMessageDispatcher : ISingletonDependency
{
    private readonly IEnumerable<IMqttMessageHandler> handlers;
    private readonly ILogger<MqttMessageDispatcher> logger;

    public MqttMessageDispatcher(
        IEnumerable<IMqttMessageHandler> handlers,
        ILogger<MqttMessageDispatcher> logger)
    {
        this.handlers = handlers.OrderBy(h => h.Priority).ToList();
        this.logger = logger;
    }

    /// <summary>
    /// 分发消息到匹配的处理器
    /// </summary>
    public async Task DispatchAsync(InterceptingPublishEventArgs args)
    {
        var topic = args.ApplicationMessage.Topic;
        var handlers = this.handlers.Where(h => h.CanHandle(topic)).ToList();

        if (handlers.Count == 0)
        {
            logger.LogDebug("No handler found for topic: {Topic}", topic);
            return;
        }

        var clientIp = args.SessionItems["ClientIP"]?.ToString();
        foreach (var handler in handlers)
        {
            try
            {
                await handler.HandleAsync(args.ApplicationMessage, clientIp);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Handler {HandlerType} failed to process message from topic: {Topic}",
                    handler.GetType().Name, topic);
            }
        }
    }
}
