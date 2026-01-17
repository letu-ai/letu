using Letu.Basis.Admin.Integrations;
using Letu.Basis.Amaps;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.Integrations;

[Authorize]
[ApiController]
[Route("/api/admin/integrations/amap")]
public class AmapIntegrationController : ControllerBase
{

    private readonly IIntegrationSettingsStore integrationSettingsStore;

    public AmapIntegrationController(IIntegrationSettingsStore integrationSettingsStore)
    {
        this.integrationSettingsStore = integrationSettingsStore;
    }

    [HttpGet]
    [Authorize(BasisPermissions.Integration.Amap)]
    public async Task<AmapSettings> GetIntegrationSettingsAsync()
    {
        return await integrationSettingsStore.GetValuesAsync<AmapSettings>("amap") ?? new();
    }

    [HttpPost]
    [Authorize(BasisPermissions.Integration.Amap)]
    public async Task SetIntegrationSettingsAsync(AmapSettings input)
    {
        await integrationSettingsStore.SetValuesAsync("amap", input);
    }
}
