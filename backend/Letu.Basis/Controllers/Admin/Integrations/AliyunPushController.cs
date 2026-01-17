using Letu.Basis.Admin.Integrations;
using Letu.Basis.AliyunPush;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.Integrations;

[Authorize]
[ApiController]
[Route("/api/admin/integrations/aliyun-push")]
public class AliyunPushIntegrationController : ControllerBase
{
    private readonly IIntegrationSettingsStore integrationSettingsStore;

    public AliyunPushIntegrationController(IIntegrationSettingsStore integrationSettingsStore)
    {
        this.integrationSettingsStore = integrationSettingsStore;
    }

    /// <summary>
    /// 获取阿里云移动推送集成配置
    /// </summary>
    /// <returns>配置信息</returns>
    [HttpGet]
    [Authorize(BasisPermissions.Integration.AliyunPush)]
    public async Task<AliyunPushSettings> GetIntegrationSettingsAsync()
    {
        return await integrationSettingsStore.GetValuesAsync<AliyunPushSettings>("aliyun-push") ?? new();
    }

    /// <summary>
    /// 设置阿里云移动推送集成配置
    /// </summary>
    /// <param name="input">配置参数</param>
    [HttpPost]
    [Authorize(BasisPermissions.Integration.AliyunPush)]
    public async Task SetIntegrationSettingsAsync(AliyunPushSettings input)
    {
        await integrationSettingsStore.SetValuesAsync("aliyun-push", input);
    }
}

