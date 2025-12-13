using Letu.AI.RagFlow;
using Letu.Basis.Admin.Integrations;
using Letu.AI.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.AI.Controllers;

[Authorize]
[ApiController]
[Route("/api/ai/ragflow")]
public class RagflowController : ControllerBase
{
    private readonly Lazy<IIntegrationSettingsStore> integrationSettingsStore;

    public RagflowController(Lazy<IIntegrationSettingsStore> integrationSettingsStore)
    {
        this.integrationSettingsStore = integrationSettingsStore;
    }


    [HttpGet("/api/admin/integrations/ragflow")]
    [Authorize(AIPermissions.Integration.RagFlow)]
    public async Task<RagflowSettings> GetIntegrationSettingsAsync()
    {
        return await integrationSettingsStore.Value.GetValuesAsync<RagflowSettings>("ragflow") ?? new();
    }

    [HttpPost("/api/admin/integrations/ragflow")]
    [Authorize(AIPermissions.Integration.RagFlow)]
    public async Task SetIntegrationSettingsAsync(RagflowSettings input)
    {
        await integrationSettingsStore.Value.SetValuesAsync("ragflow", input);
    }
}
