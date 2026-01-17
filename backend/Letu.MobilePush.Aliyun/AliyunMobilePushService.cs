using AlibabaCloud.SDK.Push20160801.Models;
using Letu.Basis.Admin.Integrations;
using Letu.Basis.AliyunPush;
using Microsoft.Extensions.Logging;
using Volo.Abp.DependencyInjection;

namespace Letu.MobilePush.Aliyun;

/// <summary>
/// 阿里云移动推送服务实现
/// </summary>
public class AliyunMobilePushService : IMobilePushService, ITransientDependency
{
    private readonly IIntegrationSettingsStore settingsStore;
    private readonly AliyunPushClientFactory clientFactory;
    private readonly ILogger<AliyunMobilePushService> logger;

    public AliyunMobilePushService(
        IIntegrationSettingsStore settingsStore,
        AliyunPushClientFactory clientFactory,
        ILogger<AliyunMobilePushService> logger)
    {
        this.settingsStore = settingsStore;
        this.clientFactory = clientFactory;
        this.logger = logger;
    }

    public async Task<PushResult> PushToDeviceAsync(
        PushType pushType,
        string packageName,
        List<string> deviceIds,
        string title,
        string body)
    {
        return await PushAsync(
            pushType,
            packageName,
            deviceIds,
            title,
            body,
            "DEVICE");
    }

    public async Task<PushResult> PushToAccountAsync(
        PushType pushType,
        string packageName,
        List<string> accounts,
        string title,
        string body)
    {
        return await PushAsync(
            pushType,
            packageName,
            accounts,
            title,
            body,
            "ACCOUNT");
    }

    private async Task<PushResult> PushAsync(
        PushType pushType,
        string packageName,
        List<string> targetValues,
        string title,
        string body,
        string target)
    {
        var settings = await GetSettingsAsync();
        var appConfig = FindAppByPackageName(settings, packageName);
        var client = clientFactory.CreateClient(settings, appConfig);

        var request = new PushRequest
        {
            AppKey = long.Parse(appConfig.AppKey!),
            Target = target,
            TargetValue = string.Join(",", targetValues),
            DeviceType = "ALL",
            PushType = pushType == PushType.Notification ? "NOTICE": "MESSAGE",
            Title = title,
            Body = body
        };

        try
        {
            var runtime = new AlibabaCloud.TeaUtil.Models.RuntimeOptions();
            var response = await client.PushWithOptionsAsync(request, runtime);

            logger.LogInformation(
                "阿里云推送成功: PackageName={PackageName}, 数量={Count}, MessageId={MessageId}",
                packageName, targetValues.Count, response.Body.MessageId);

            return new PushResult
            {
                Success = true,
                MessageId = long.Parse(response.Body.MessageId),
                RequestId = response.Body.RequestId
            };
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "阿里云推送失败: PackageName={PackageName}", packageName);
            throw new Exception("阿里云推送失败", ex);
        }
    }

    private async Task<AliyunPushSettings> GetSettingsAsync()
    {
        var isEnabled = await settingsStore.IsEnabledAsync("aliyun-push");
        if (!isEnabled)
        {
            throw new Exception("阿里云推送未启用");
        }

        var settings = await settingsStore.GetValuesAsync<AliyunPushSettings>("aliyun-push");
        if (settings == null)
        {
            throw new Exception("阿里云推送配置不存在");
        }

        return settings;
    }

    private static AliyunPushApp FindAppByPackageName(AliyunPushSettings settings, string packageName)
    {
        var appConfig = settings.Apps.FirstOrDefault(x => x.PackageName == packageName);
        if (appConfig == null)
        {
            throw new Exception($"未找到包名为 {packageName} 的应用配置");
        }

        return appConfig;
    }
}
