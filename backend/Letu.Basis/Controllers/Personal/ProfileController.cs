using Letu.Basis.Personal.Profiles;
using Letu.Basis.Personal.Profiles.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Personal;

[Route("/api/my/profile")]
[ApiController]
[Authorize]
public class ProfileController : ControllerBase
{
    private readonly IProfileAppService profileAppService;
    private readonly ILogger<ProfileController> logger;

    public ProfileController(IProfileAppService profileAppService, ILogger<ProfileController> logger)
    {
        this.profileAppService = profileAppService;
        this.logger = logger;
    }

    [HttpGet]
    public async Task<ProfileOutput> GetProfileAsync()
    {
        return await profileAppService.GetProfileAsync();
    }

    [HttpPut]
    public async Task<ProfileOutput> UpdateProfileAsync(ProfileUpdateInput input)
    {
        return await profileAppService.UpdateProfileAsync(input);
    }

    [HttpPut("change-password")]
    public async Task ChangePasswordAsync(ChangePasswordInput input)
    {
        await profileAppService.ChangePasswordAsync(input);

    }

    [HttpPost("avatar")]
    public async Task<string> UploadAvatarAsync(AvatarUploadInput input)
    {
        return await profileAppService.UploadAvatarAsync(input);
    }

    [HttpGet("avatar")]
    public async Task<IActionResult> GetAvatarAsync(CancellationToken cancellationToken)
    {
        try
        {
            var (stream, contentType) = await profileAppService.GetAvatarAsync(cancellationToken);
            if (stream == null)
            {
                return NotFound();
            }

            return File(stream, contentType, enableRangeProcessing: true);
        }
        catch (OperationCanceledException)
        {
            // 客户端取消请求，返回204 No Content
            return NoContent();
        }
        catch
        {
            throw;
        }
    }


    /// <summary>
    /// 获取个人登录日志列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpGet("security-logs")]
    public async Task<PagedResult<SecurityLogListDto>> GetSecurityLogsAsync([FromQuery] SecurityLogQueryInput input)
    {
        return await profileAppService.GetSecurityLogsAsync(input);
    }

    /// <summary>
    /// 获取个人登录统计信息
    /// </summary>
    /// <returns></returns>
    [HttpGet("security-logs/stats")]
    public async Task<SecurityLogStatsDto> GetSecurityLogStatsAsync()
    {
        return await profileAppService.GetSecurityLogStatsAsync();
    }
}
