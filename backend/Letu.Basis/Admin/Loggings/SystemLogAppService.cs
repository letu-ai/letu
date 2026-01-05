using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 日志文件管理应用服务
/// </summary>
public class SystemLogAppService : BasisAppService, ISystemLogAppService
{
    private readonly ILogFileManagementService logFileManagementService;

    public SystemLogAppService(ILogFileManagementService logFileManagementService)
    {
        this.logFileManagementService = logFileManagementService;
    }

    public async Task<PagedResult<SystemLogListOutput>> GetLogFilesAsync(SystemLogListInput input)
    {
        return await logFileManagementService.GetLogFilesAsync(input);
    }

    public async Task<SystemLogContentOutput> ReadLogFileContentAsync(string filePath, int skip, int take)
    {
        return await logFileManagementService.ReadLogFileContentAsync(filePath, skip, take);
    }

    public async Task<FileStreamResult> DownloadLogFileAsync(string filePath)
    {
        var stream = await logFileManagementService.DownloadLogFileAsync(filePath);
        var fileName = Path.GetFileName(filePath);
        var contentType = filePath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase) 
            ? "application/zip" 
            : "text/plain";
        
        return new FileStreamResult(stream, contentType)
        {
            FileDownloadName = fileName
        };
    }
}

