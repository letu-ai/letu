using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 日志文件管理应用服务接口
/// </summary>
public interface ISystemLogAppService
{
    /// <summary>
    /// 获取日志文件列表
    /// </summary>
    Task<PagedResult<SystemLogListOutput>> GetLogFilesAsync(SystemLogListInput dto);

    /// <summary>
    /// 读取日志文件内容（分页）
    /// </summary>
    Task<SystemLogContentOutput> ReadLogFileContentAsync(string filePath, int skip, int take);

    /// <summary>
    /// 下载日志文件
    /// </summary>
    Task<FileStreamResult> DownloadLogFileAsync(string filePath);
}