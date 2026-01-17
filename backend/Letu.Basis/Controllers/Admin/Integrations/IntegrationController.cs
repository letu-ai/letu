using Letu.Basis.Admin.Integrations;
using Microsoft.AspNetCore.Mvc;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;

namespace Letu.Basis.Controllers.Admin.Integrations;

[ApiController]
[Route("/api/admin/integrations")]
public class IntegrationController : ControllerBase
{
    private readonly IIntegrationSettingsStore settingStore;

    public IntegrationController(IIntegrationSettingsStore settingStore)
    {
        this.settingStore = settingStore;
    }

    [HttpGet("enable-status")]
    public async Task<List<IntegrationEnableStatusOutput>> GetIntegrationEnableStatusListAsync()
    {
        return await settingStore.GetListAsync();
    }

    [HttpGet("enable-status/{name}")]
    public async Task<bool> GetIntegrationEnableStatusAsync(string name)
    {
        return await settingStore.IsEnabledAsync(name);
    }

    [HttpPut("enable-status/{name}")]
    [Authorize(BasisPermissions.Integration.Default)]
    public async Task SetIntegrationEnableStatusAsync(string name, bool enabled)
    {
        await settingStore.SetEnabledAsync(name, enabled);
    }
}
