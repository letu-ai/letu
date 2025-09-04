using Letu.Basis.Account;
using Letu.Basis.Account.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Accont;

[Authorize]
[ApiController]
[Route("api/account")]
public class AccountController : AbpControllerBase
{
    private readonly IAccountAppService accountAppService;

    public AccountController(IAccountAppService accountAppService)
    {
        this.accountAppService = accountAppService;
    }

    [AllowAnonymous]
    [HttpGet("login-settings")]
    public async Task<LoginSettingsOutput> OnGetLoginSettingsAsync()
    {
        return await accountAppService.GetLoginSettingsAsync();
    }

    [AllowAnonymous]
    [HttpPost("switch-tenant")]
    public async Task<SwitchTenantOutput> SwitchTenant(string? tenantName)
    {
        return await accountAppService.SwitchTenantAsync(tenantName);
    }
}