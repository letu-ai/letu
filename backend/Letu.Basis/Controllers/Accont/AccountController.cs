using Letu.Basis.Account;
using Letu.Basis.Account.Dtos;
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
[Route("api/account")]
public class AccountController : AbpControllerBase
{
    private readonly IAccountAppService accountService;
    private readonly IIdentityAppService identityAppService;

    public AccountController(IAccountAppService accountService, IIdentityAppService identityAppService)
    {
        this.accountService = accountService;
        this.identityAppService = identityAppService;
    }

    /// <summary>
    /// 登录
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [AllowAnonymous]
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
    [HttpPost("refresh-token")]
    public async Task<UserTokenOutput> RefreshToken(RefreshTokenInput input)
    {
        return await identityAppService.RefreshTokenAsync(input.RefreshToken);
    }


    /// <summary>
    /// 修改个人基本信息
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPut("updateInfo")]
    public async Task UpdateUserInfoAsync([FromBody] UserInfoUpdateInput dto)
    {
        await accountService.UpdateUserInfoAsync(dto);
    }

    /// <summary>
    /// 修改个人密码
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPut("updatePwd")]
    public async Task UpdateUserPwdAsync([FromBody] ChangePasswordInput dto)
    {
        await accountService.UpdateUserPwdAsync(dto);
    }

    /// <summary>
    /// 用户权限信息
    /// </summary>
    /// <returns></returns>
    [HttpGet("userAuth")]
    public async Task<UserAuthInfoOutput> GetUserAuthInfoAsync()
    {
        var data = await accountService.GetUserAuthInfoAsync();
        return data;
    }
}