using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

/// <summary>
/// 日志文件管理控制器
/// </summary>
[Authorize(BasisPermissions.Logging.SystemLog)]
[ApiController]
[Route("api/admin/logs/system")]
public class SystemLogController : ControllerBase
{
    private readonly ISystemLogAppService logFileAppService;

    public SystemLogController(ISystemLogAppService logFileAppService)
    {
        this.logFileAppService = logFileAppService;
    }

    /// <summary>
    /// 获取日志文件列表
    /// </summary>
    [HttpGet]
    public async Task<PagedResult<SystemLogListOutput>> GetLogFilesAsync([FromQuery] SystemLogListInput dto)
    {
        return await logFileAppService.GetLogFilesAsync(dto);
    }

    /// <summary>
    /// 读取日志文件内容（分页）
    /// </summary>
    [HttpGet("content")]
    public async Task<SystemLogContentOutput> ReadLogFileContentAsync(
        [FromQuery] string filePath,
        [FromQuery] int skip = 0,
        [FromQuery] int take = 100)
    {
        return await logFileAppService.ReadLogFileContentAsync(filePath, skip, take);
    }

    /// <summary>
    /// 下载日志文件
    /// </summary>
    [HttpGet("download/{*filePath}")]
    public async Task<IActionResult> DownloadLogFileAsync(string filePath)
    {
        var result = await logFileAppService.DownloadLogFileAsync(filePath);
        return result;
    }
}

