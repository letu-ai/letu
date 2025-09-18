using Letu.Basis.Account;
using Letu.Basis.Identity;
using Letu.Basis.Identity.Dtos;
using Letu.Shared.Consts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Accont;

[Authorize]
[ApiController]
[Route("api/identity")]
public class IdentityController : AbpControllerBase
{
    private readonly IIdentityAppService identityAppService;

    public IdentityController(IIdentityAppService identityAppService)
    {
        this.identityAppService = identityAppService;
    }

    /// <summary>
    /// 登录
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [AllowAnonymous]
    [IgnoreAntiforgeryToken]
    [HttpPost("login")]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task<UserTokenOutput> LoginAsync([FromBody] LoginInput input)
    {
        return await identityAppService.LoginAsync(input);
    }

    /// <summary>
    /// 注销
    /// </summary>
    /// <returns></returns>
    [HttpPost("logout")]
    [IgnoreAntiforgeryToken]
    [AllowAnonymous]
    public async Task LogoutAsync()
    {
        await identityAppService.LogoutAsync();
    }

    /// <summary>
    /// 刷新token
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [AllowAnonymous]
    [IgnoreAntiforgeryToken]
    [HttpPost("refresh-token")]
    public async Task<UserTokenOutput> RefreshTokenAsync(RefreshTokenInput input)
    {
        return await identityAppService.RefreshTokenAsync(input.RefreshToken);
    }
}