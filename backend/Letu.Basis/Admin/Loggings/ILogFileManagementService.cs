using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings;

public interface ILogFileManagementService
{
    Task<int> CleanupExpiredFilesAsync();
    Task CompressLogFileAsync(string filePath, bool keepSourceFile = false);
    Task<int> CompressOldFilesAsync();
    Task DeleteLogFileAsync(string filePath);
    Task<Stream> DownloadLogFileAsync(string filePath);
    Task<PagedResult<SystemLogListOutput>> GetLogFilesAsync(SystemLogListInput input);
    Task<SystemLogContentOutput> ReadLogFileContentAsync(string filePath, int skip, int take);
}