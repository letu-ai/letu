using Letu.AI.Fastgpt;
using Letu.Basis.Admin.Integrations;
using Letu.AI.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.AI.Controllers;

[Authorize]
[ApiController]
[Route("/api/ai/fastgpt")]
public class FastgptController : ControllerBase
{
    private readonly Lazy<IIntegrationSettingsStore> integrationSettingsStore;

    public FastgptController(Lazy<IIntegrationSettingsStore> integrationSettingsStore)
    {
        this.integrationSettingsStore = integrationSettingsStore;
    }

    [HttpGet("/api/admin/integrations/fastgpt")]
    [Authorize(AIPermissions.Integration.FastGpt)]
    public async Task<FastgptSettings> GetIntegrationSettingsAsync()
    {
        return await integrationSettingsStore.Value.GetValuesAsync<FastgptSettings>("fastgpt") ?? new();
    }

    [HttpPost("/api/admin/integrations/fastgpt")]
    [Authorize(AIPermissions.Integration.FastGpt)]
    public async Task SetIntegrationSettingsAsync(FastgptSettings input)
    {
        await integrationSettingsStore.Value.SetValuesAsync("fastgpt", input);
    }
}
