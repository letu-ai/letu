using Letu.Mqtt.Handlers;
using Letu.Mqtt.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using MQTTnet.AspNetCore;
using MQTTnet.Server;
using Volo.Abp;
using Volo.Abp.AspNetCore;
using Volo.Abp.Modularity;

namespace Letu.Mqtt;

[DependsOn(
    typeof(AbpAspNetCoreModule)
)]
public class LetuMqttModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var configuration = context.Services.GetConfiguration();
        var services = context.Services;

        // 配置选项
        var mqttSection = configuration.GetSection("Mqtt");
        services.Configure<MqttOptions>(mqttSection);

        // 读取配置并检查是否启用 MQTT
        var mqttOptions = mqttSection.Get<MqttOptions>() ?? new MqttOptions();
        if (mqttOptions.IsEnabled)
        {
            ConfigureMqtt(services, configuration, mqttOptions);
            ConfigureEndpointRouter();
        }
    }

    private void ConfigureMqtt(IServiceCollection services, IConfiguration configuration, MqttOptions mqttOptions)
    {
        services.Configure<KestrelServerOptions>(options =>
        {
            options.ListenAnyIP(mqttOptions.Port, l => l.UseMqtt());
        });

        services.AddHostedMqttServer(
               optionsBuilder =>
               {
                   optionsBuilder.WithDefaultEndpoint();
               });

        services.AddMqttConnectionHandler();
        services.AddConnections();
    }

    private void ConfigureEndpointRouter()
    {
        Configure<AbpEndpointRouterOptions>(options =>
        {
            options.EndpointConfigureActions.Add(endpointContext =>
            {
                endpointContext.Endpoints.MapConnectionHandler<MqttConnectionHandler>("/api/mqtt");
            });
        });
    }

    public override void OnApplicationInitialization(ApplicationInitializationContext context)
    {
        var mqttOptions = context.ServiceProvider.GetRequiredService<IOptions<MqttOptions>>().Value;

        // 如果 MQTT 未启用，则跳过初始化
        if (!mqttOptions.IsEnabled)
        {
            return;
        }

        var app = context.GetApplicationBuilder();
        var connectionManager = context.ServiceProvider.GetRequiredService<MqttConnectionManager>();
        var dispatcher = context.ServiceProvider.GetRequiredService<MqttMessageDispatcher>();

        app.UseMqttServer(server =>
        {
            server.ClientConnectedAsync += connectionManager.OnClientConnectedAsync;
            server.ValidatingConnectionAsync += connectionManager.OnValidatingConnectionAsync;
            server.InterceptingPublishAsync += dispatcher.DispatchAsync;
        });
    }

    public override async Task OnApplicationShutdownAsync(ApplicationShutdownContext context)
    {
        var mqttOptions = context.ServiceProvider.GetRequiredService<IOptions<MqttOptions>>().Value;
        var logger = context.ServiceProvider.GetRequiredService<ILogger<LetuMqttModule>>();

        // 如果 MQTT 未启用，则跳过关闭
        if (!mqttOptions.IsEnabled)
        {
            return;
        }

        try
        {
            logger.LogInformation("正在关闭 MQTT 服务器...");

            // 获取 MQTT 服务器实例
            var mqttServer = context.ServiceProvider.GetService<MqttServer>();
            if (mqttServer != null)
            {
                // 优雅关闭 MQTT 服务器，断开所有客户端连接
                await mqttServer.StopAsync();
                logger.LogInformation("MQTT 服务器已成功关闭");
            }
            else
            {
                logger.LogWarning("MQTT 服务器实例未找到，可能已经关闭");
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "关闭 MQTT 服务器时发生错误");
            // 不抛出异常，确保服务可以正常退出
        }
    }
}