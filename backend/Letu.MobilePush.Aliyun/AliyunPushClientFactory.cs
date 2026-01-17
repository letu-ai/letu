using AlibabaCloud.OpenApiClient.Models;
using AlibabaCloud.SDK.Push20160801;
using Letu.Basis.AliyunPush;
using Microsoft.Extensions.Logging;
using Volo.Abp.DependencyInjection;

namespace Letu.MobilePush.Aliyun;

/// <summary>
/// 阿里云推送客户端工厂
/// </summary>
public class AliyunPushClientFactory : ITransientDependency
{
    private readonly ILogger<AliyunPushClientFactory> logger;

    public AliyunPushClientFactory(ILogger<AliyunPushClientFactory> logger)
    {
        this.logger = logger;
    }

    public Client CreateClient(
        AliyunPushSettings settings,
        AliyunPushApp appConfig)
    {
        var config = new Config
        {
            Endpoint = settings.Endpoint,
            RegionId = settings.RegionId,
            AccessKeyId = settings.AccessKeyId,
            AccessKeySecret = settings.AccessKeySecret,
        };

        var client = new Client(config);

        return client;
    }
}
