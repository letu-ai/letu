using Letu.Basis.Application;
using Letu.Basis.Application.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers;

[ApiController]
[Authorize]
[Route("/api/application")]
public class ApplicationController : ControllerBase
{
    private readonly ILetuApplicationConfigurationAppService applicationConfigurationAppService;

    public ApplicationController(
        ILetuApplicationConfigurationAppService applicationConfigurationAppService)
    {
        this.applicationConfigurationAppService = applicationConfigurationAppService;
    }

    [AllowAnonymous]
    [HttpGet("configuration")]
    public async Task<LetuApplicationConfigurationDto> GetAsync([FromQuery]LetuApplicationConfigurationRequestOptions options)
    {
        return await applicationConfigurationAppService.GetAsync(options);
    }
}
