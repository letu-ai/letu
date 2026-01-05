using Letu.Mqtt.Handlers;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using MQTTnet.Server;
using Volo.Abp.DependencyInjection;

namespace Letu.Mqtt;

public class MqttConnectionManager: ISingletonDependency
{
    private readonly MqttMessageDispatcher messageDispatcher;
    private readonly ILogger<MqttConnectionManager> logger;
    private readonly MqttOptions options;

    public MqttConnectionManager(
        MqttMessageDispatcher messageDispatcher,
        ILogger<MqttConnectionManager> logger,
        IOptions<MqttOptions> options)
    {
        this.messageDispatcher = messageDispatcher;
        this.logger = logger;
        this.options = options.Value;
    }

    public Task OnClientConnectedAsync(ClientConnectedEventArgs args)
    {
        // 获取客户端IP地址
        var clientIp = args.RemoteEndPoint?.ToString();
        var clientId = args.ClientId;
        
        logger.LogInformation("MQTT Client {ClientIp} connected:  {ClientId}", clientIp, clientId);

        // 你可以将IP地址存储在上下文中供后续使用
        args.SessionItems["ClientIP"] = clientIp; 
        
        return Task.CompletedTask;
    }

    public Task OnValidatingConnectionAsync(ValidatingConnectionEventArgs args)
    {
        // 如果配置了用户名和密码,进行验证
        if (!string.IsNullOrEmpty(options.Username) && !string.IsNullOrEmpty(options.Password))
        {
            if (args.UserName != options.Username || args.Password != options.Password)
            {
                args.ReasonCode = MQTTnet.Protocol.MqttConnectReasonCode.BadUserNameOrPassword;
                logger.LogWarning("MQTT Client {ClientIp} authentication failed: {ClientId}", args.RemoteEndPoint, args.ClientId);
                return Task.CompletedTask;
            }
        }

        logger.LogInformation("MQTT Client {ClientIp} accepted: {ClientId}", args.RemoteEndPoint, args.ClientId);
        return Task.CompletedTask;
    }
}