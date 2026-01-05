using System.Net;
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
    const string deviceIdCookieName = "__letu_did";

    public AccountController(IAccountAppService accountAppService)
    {
        this.accountAppService = accountAppService;
    }

    [AllowAnonymous]
    [HttpGet("login-settings")]
    public async Task<LoginSettingsOutput> OnGetLoginSettingsAsync()
    {
        // 检查并设置设备ID Cookie
        EnsureDeviceIdCookie();

        return await accountAppService.GetLoginSettingsAsync();
    }

    [AllowAnonymous]
    [HttpPost("switch-tenant")]
    public async Task<SwitchTenantOutput> SwitchTenant(string? tenantName)
    {
        var result = await accountAppService.SwitchTenantAsync(tenantName);
        if (result.Success)
        {
            // 设置Cookie选项
            var cookieOptions = new CookieOptions
            {
                Path = "/",
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Lax,
            };

            if (result.TenantId.HasValue)
            {
                // 如果租户ID存在，设置Cookie
                cookieOptions.MaxAge = TimeSpan.FromSeconds(31536000); // 1年
                Response.Cookies.Append(result.CookieKey, result.TenantId.ToString()!, cookieOptions);
            }
            else
            {
                // 如果租户ID为空表示登录主站，则删除Cookie
                Response.Cookies.Delete(result.CookieKey, cookieOptions);
            }

            return result;
        }

        return result;
    }

    
    /// <summary>
    /// 确保设备ID Cookie存在，如果不存在则创建一个
    /// </summary>
    private void EnsureDeviceIdCookie()
    {

        // 检查Cookie中是否已有设备ID
        if (!Request.Cookies.ContainsKey(deviceIdCookieName))
        {
            // 生成新的设备ID（使用GUID）
            var deviceId = Guid.NewGuid().ToString("N");

            // 设置Cookie选项
            var cookieOptions = new CookieOptions
            {
                HttpOnly = true,
                Secure = Request.IsHttps,
                SameSite = SameSiteMode.Lax,
                Path = "/",
                Expires = DateTimeOffset.UtcNow.AddYears(999) // 有效期999年
            };

            // 设置Cookie
            Response.Cookies.Append(deviceIdCookieName, deviceId, cookieOptions);
        }
    }

}