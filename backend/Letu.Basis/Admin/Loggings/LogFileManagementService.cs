using Letu.Basis.Admin.Loggings.Dtos;
using System.IO.Compression;
using System.Text.RegularExpressions;
using Letu.Logging;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using Volo.Abp.DependencyInjection;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 日志文件管理服务
/// </summary>
public partial class LogFileManagementService : ILogFileManagementService, ISingletonDependency
{
    private readonly ILogger<LogFileManagementService> logger;
    private readonly IOptions<LogManagementOptions> logManagementOptions;
    private readonly IMemoryCache memoryCache;
    private readonly string logDirectory;
    private const string LineCountCacheKeyPrefix = "log_file_line_count:";
    private static readonly TimeSpan CacheExpiration = TimeSpan.FromMinutes(10);

    [GeneratedRegex(@"^\d{4}-\d{2}$")]
    private static partial Regex YearMonthDirectoryRegex();

    /// <summary>
    /// 从文件名中解析日期
    /// 支持格式：log20231201.txt, log-2023-12-01.txt, log20231201001.txt 等
    /// </summary>
    private DateTime? ParseDateFromFileName(string fileName)
    {
        // 如果是压缩文件，先去掉 .zip 后缀
        var nameWithoutExtension = fileName;
        if (fileName.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
        {
            nameWithoutExtension = fileName.Substring(0, fileName.Length - 4);
        }

        // 去掉文件扩展名
        var nameWithoutZipAndExt = Path.GetFileNameWithoutExtension(nameWithoutExtension);

        // 尝试匹配 yyyyMMdd 格式（如 log20231201）
        var datePattern1 = @"(\d{4})(\d{2})(\d{2})";
        var match1 = System.Text.RegularExpressions.Regex.Match(nameWithoutZipAndExt, datePattern1);
        if (match1.Success)
        {
            if (int.TryParse(match1.Groups[1].Value, out var year) &&
                int.TryParse(match1.Groups[2].Value, out var month) &&
                int.TryParse(match1.Groups[3].Value, out var day))
            {
                try
                {
                    return new DateTime(year, month, day);
                }
                catch
                {
                    // 日期无效，继续尝试其他格式
                }
            }
        }

        // 尝试匹配 yyyy-MM-dd 格式（如 log-2023-12-01）
        var datePattern2 = @"(\d{4})-(\d{2})-(\d{2})";
        var match2 = System.Text.RegularExpressions.Regex.Match(nameWithoutZipAndExt, datePattern2);
        if (match2.Success)
        {
            if (int.TryParse(match2.Groups[1].Value, out var year) &&
                int.TryParse(match2.Groups[2].Value, out var month) &&
                int.TryParse(match2.Groups[3].Value, out var day))
            {
                try
                {
                    return new DateTime(year, month, day);
                }
                catch
                {
                    // 日期无效
                }
            }
        }

        return null;
    }

    public LogFileManagementService(IOptions<LogManagementOptions> logManagementOptions, ILogger<LogFileManagementService> logger, IMemoryCache memoryCache)
    {
        this.logManagementOptions = logManagementOptions;
        this.logger = logger;
        this.memoryCache = memoryCache;
        var logDir = this.logManagementOptions.Value.SystemLog.LogDirectory;
        logDirectory = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, logDir);
    }

    /// <summary>
    /// 获取日志文件列表
    /// </summary>
    public Task<PagedResult<SystemLogListOutput>> GetLogFilesAsync(SystemLogListInput input)
    {
        var files = new List<SystemLogListOutput>();

        if (!Directory.Exists(logDirectory))
        {
            return Task.FromResult(new PagedResult<SystemLogListOutput>(input, 0, files));
        }

        // 获取所有月份目录
        var monthDirs = Directory.GetDirectories(logDirectory)
            .Where(d => YearMonthDirectoryRegex().IsMatch(Path.GetFileName(d)))
            .OrderByDescending(d => d);

        foreach (var monthDir in monthDirs)
        {
            var month = Path.GetFileName(monthDir);

            // 月份筛选
            if (!string.IsNullOrEmpty(input.Month) && month != input.Month)
            {
                continue;
            }

            var monthFiles = Directory.GetFiles(monthDir)
                .Select(filePath =>
                {
                    var fileInfo = new FileInfo(filePath);
                    var fileName = fileInfo.Name;
                    var isCompressed = fileName.EndsWith(".zip", StringComparison.OrdinalIgnoreCase);

                    // 从文件名解析日期，如果解析失败则跳过该文件
                    var creationTime = ParseDateFromFileName(fileName);
                    if (!creationTime.HasValue)
                    {
                        return null;
                    }

                    return new SystemLogListOutput
                    {
                        FileName = fileName,
                        FilePath = Path.GetRelativePath(logDirectory, filePath).Replace('\\', '/'),
                        FileSize = fileInfo.Length,
                        CreationTime = creationTime.Value,
                        LastWriteTime = fileInfo.LastWriteTime,
                        IsCompressed = isCompressed,
                        Month = month
                    };
                })
                .Where(f => f != null)
                .ToList();

                files.AddRange(monthFiles!);
        }

        // 排序：按创建时间（文件名中的日期）倒序
        files = files.OrderByDescending(f => f.CreationTime).ToList();

        // 分页
        if (input.Current > 0 && input.PageSize > 0)
        {
            var skip = (input.Current - 1) * input.PageSize;
            files = files.Skip(skip).Take(input.PageSize).ToList();
        }

        return Task.FromResult(new PagedResult<SystemLogListOutput>(input, files.Count, files));
    }

    /// <summary>
    /// 读取日志文件内容（分页）
    /// </summary>
    public async Task<SystemLogContentOutput> ReadLogFileContentAsync(string filePath, int skip, int take)
    {
        var fullPath = GetFullPath(filePath);

        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"日志文件不存在: {filePath}");
        }

        var fileInfo = new FileInfo(fullPath);
        var isCompressed = fullPath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase);
        var lines = new List<string>();

        // 尝试从缓存获取总行数
        var cacheKey = GetLineCountCacheKey(fullPath, fileInfo.LastWriteTime);
        var totalLines = await GetCachedLineCountAsync(cacheKey, fullPath, isCompressed);

        if (isCompressed)
        {
            // 读取压缩文件
            using var archive = ZipFile.OpenRead(fullPath);
            var entry = archive.Entries.FirstOrDefault();
            if (entry != null)
            {
                using var stream = entry.Open();
                using var reader = new StreamReader(stream);

                // 读取需要的行
                var currentLine = 0;
                string? line;
                while ((line = await reader.ReadLineAsync()) != null)
                {
                    if (currentLine >= skip && currentLine < skip + take)
                    {
                        lines.Add(line);
                    }
                    currentLine++;
                    if (currentLine >= skip + take)
                    {
                        break;
                    }
                }
            }
        }
        else
        {
            // 读取普通文件 - 优化版本：不加载全部内容到内存
            // 使用只读模式打开，但允许其他进程写入（FileShare.ReadWrite）
            using var fileStream = new FileStream(fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            using var reader = new StreamReader(fileStream);

            // 读取需要的行
            var currentLine = 0;
            string? tempLine;
            while ((tempLine = await reader.ReadLineAsync()) != null)
            {
                if (currentLine >= skip && currentLine < skip + take)
                {
                    lines.Add(tempLine);
                }
                currentLine++;
                if (currentLine >= skip + take)
                {
                    break;
                }
            }
        }

        return new SystemLogContentOutput
        {
            Lines = lines,
            TotalLines = totalLines,
            Skip = skip,
            Take = take,
            HasMore = skip + take < totalLines
        };
    }

    /// <summary>
    /// 获取缓存的总行数，如果不存在则计算并缓存
    /// </summary>
    private async Task<long> GetCachedLineCountAsync(string cacheKey, string fullPath, bool isCompressed)
    {
        // 尝试从缓存获取
        if (memoryCache.TryGetValue<long>(cacheKey, out var cachedLineCount))
        {
            return cachedLineCount;
        }

        // 缓存未命中，计算总行数
        long lineCount = 0L;

        if (isCompressed)
        {
            // 读取压缩文件
            using var archive = ZipFile.OpenRead(fullPath);
            var entry = archive.Entries.FirstOrDefault();
            if (entry != null)
            {
                using var stream = entry.Open();
                using var reader = new StreamReader(stream);

                string? line;
                while ((line = await reader.ReadLineAsync()) != null)
                {
                    lineCount++;
                }
            }
        }
        else
        {
            // 读取普通文件
            // 使用只读模式打开，但允许其他进程写入（FileShare.ReadWrite）
            using var fileStream = new FileStream(fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            using var reader = new StreamReader(fileStream);
            string? tempLine;
            while ((tempLine = await reader.ReadLineAsync()) != null)
            {
                lineCount++;
            }
        }

        // 存入缓存，10分钟过期
        memoryCache.Set(cacheKey, lineCount, CacheExpiration);

        return lineCount;
    }

    /// <summary>
    /// 获取行数缓存的键（基于文件路径和最后修改时间）
    /// </summary>
    private string GetLineCountCacheKey(string fullPath, DateTime lastWriteTime)
    {
        // 使用文件路径和最后修改时间作为缓存键的一部分，这样文件被修改后缓存会自动失效
        var key = $"{LineCountCacheKeyPrefix}{fullPath}:{lastWriteTime:yyyyMMddHHmmss}";
        return key;
    }

    /// <summary>
    /// 清除文件的行数缓存
    /// </summary>
    private void ClearLineCountCache(string fullPath)
    {
        // 由于缓存键包含最后修改时间，我们无法精确匹配旧的缓存键
        // 但可以通过文件路径前缀来清除相关缓存（如果需要的话）
        // 实际上，由于缓存键包含最后修改时间，文件修改后旧缓存会自动失效
        // 这里可以留空，或者实现一个更复杂的缓存清理机制
    }

    /// <summary>
    /// 压缩日志文件
    /// </summary>
    /// <param name="filePath">文件路径</param>
    /// <param name="keepSourceFile">是否保留源文件，默认为 false</param>
    public Task CompressLogFileAsync(string filePath, bool keepSourceFile = false)
    {
        var fullPath = GetFullPath(filePath);

        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"日志文件不存在: {filePath}");
        }

        if (fullPath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException("文件已经压缩");
        }

        var zipPath = fullPath + ".zip";

        if (File.Exists(zipPath))
        {
            throw new InvalidOperationException("压缩文件已存在");
        }

        try
        {
            using (var archive = ZipFile.Open(zipPath, ZipArchiveMode.Create))
            {
                archive.CreateEntryFromFile(fullPath, Path.GetFileName(fullPath));
            }

            // 根据参数决定是否删除原文件
            if (!keepSourceFile)
            {
                File.Delete(fullPath);
                // 清除原文件的行数缓存
                ClearLineCountCache(fullPath);
            }

            logger.LogInformation("日志文件压缩成功: {FilePath} -> {ZipPath}, 保留源文件: {KeepSourceFile}", filePath, zipPath, keepSourceFile);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "压缩日志文件失败: {FilePath}", filePath);
            throw;
        }

        return Task.CompletedTask;
    }

    /// <summary>
    /// 删除日志文件
    /// </summary>
    public Task DeleteLogFileAsync(string filePath)
    {
        var fullPath = GetFullPath(filePath);

        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"日志文件不存在: {filePath}");
        }

        try
        {
            // 清除文件的行数缓存
            ClearLineCountCache(fullPath);

            File.Delete(fullPath);
            logger.LogInformation("日志文件删除成功: {FilePath}", filePath);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "删除日志文件失败: {FilePath}", filePath);
            throw;
        }

        return Task.CompletedTask;
    }

    /// <summary>
    /// 限制长度的流包装器，用于限制读取的长度
    /// </summary>
    private class LimitedLengthStream : Stream
    {
        private readonly Stream baseStream;
        private readonly long maxLength;
        private long position;

        public LimitedLengthStream(Stream baseStream, long maxLength)
        {
            this.baseStream = baseStream ?? throw new ArgumentNullException(nameof(baseStream));
            this.maxLength = maxLength;
            this.position = 0;
        }

        public override bool CanRead => baseStream.CanRead;

        public override bool CanSeek => baseStream.CanSeek;

        public override bool CanWrite => false;

        public override long Length => Math.Min(maxLength, baseStream.Length);

        public override long Position
        {
            get => position;
            set
            {
                if (value < 0 || value > maxLength)
                {
                    throw new ArgumentOutOfRangeException(nameof(value));
                }
                position = value;
                baseStream.Position = value;
            }
        }

        public override void Flush()
        {
            baseStream.Flush();
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            if (position >= maxLength)
            {
                return 0;
            }

            var remaining = maxLength - position;
            var bytesToRead = (int)Math.Min(count, remaining);
            var bytesRead = baseStream.Read(buffer, offset, bytesToRead);
            position += bytesRead;
            return bytesRead;
        }

        public override async Task<int> ReadAsync(byte[] buffer, int offset, int count, CancellationToken cancellationToken)
        {
            if (position >= maxLength)
            {
                return 0;
            }

            var remaining = maxLength - position;
            var bytesToRead = (int)Math.Min(count, remaining);
            var bytesRead = await baseStream.ReadAsync(buffer, offset, bytesToRead, cancellationToken);
            position += bytesRead;
            return bytesRead;
        }

        public override long Seek(long offset, SeekOrigin origin)
        {
            long newPosition;
            switch (origin)
            {
                case SeekOrigin.Begin:
                    newPosition = offset;
                    break;
                case SeekOrigin.Current:
                    newPosition = position + offset;
                    break;
                case SeekOrigin.End:
                    newPosition = maxLength + offset;
                    break;
                default:
                    throw new ArgumentException("Invalid seek origin", nameof(origin));
            }

            if (newPosition < 0 || newPosition > maxLength)
            {
                throw new ArgumentOutOfRangeException(nameof(offset));
            }

            position = newPosition;
            baseStream.Position = newPosition;
            return position;
        }

        public override void SetLength(long value)
        {
            throw new NotSupportedException("Cannot set length on LimitedLengthStream");
        }

        public override void Write(byte[] buffer, int offset, int count)
        {
            throw new NotSupportedException("Cannot write to LimitedLengthStream");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                baseStream.Dispose();
            }
            base.Dispose(disposing);
        }
    }

    /// <summary>
    /// 下载日志文件
    /// </summary>
    public async Task<Stream> DownloadLogFileAsync(string filePath)
    {
        var fullPath = GetFullPath(filePath);

        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"日志文件不存在: {filePath}");
        }

        // 获取文件信息以确定当前长度
        var fileInfo = new FileInfo(fullPath);
        var currentLength = fileInfo.Length;

        // 使用只读模式打开，但允许其他进程写入（FileShare.ReadWrite）
        var fileStream = new FileStream(fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        
        // 对于压缩文件，直接返回原始流（压缩文件通常不会在写入时下载）
        if (fullPath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
        {
            return fileStream;
        }

        // 对于普通日志文件，使用限制长度的流包装器
        // 这样即使文件继续写入，也只会下载打开时的内容
        var limitedStream = new LimitedLengthStream(fileStream, currentLength);
        return limitedStream;
    }

    /// <summary>
    /// 执行清理任务（删除过期文件）
    /// </summary>
    public Task<int> CleanupExpiredFilesAsync()
    {
        var deleteAfterDays = logManagementOptions.Value.SystemLog.RetentionDays;
        // cutoffDate 的时间部分设置为 00:00:00
        var cutoffDate = DateTime.Now.Date.AddDays(-deleteAfterDays);
        var deletedCount = 0;

        if (!Directory.Exists(logDirectory))
        {
            return Task.FromResult(0);
        }

        try
        {
            var allFiles = Directory.GetFiles(logDirectory, "*", SearchOption.AllDirectories);

            foreach (var filePath in allFiles)
            {
                var fileName = Path.GetFileName(filePath);
                // 使用 ParseDateFromFileName 获取文件日期
                var fileDate = ParseDateFromFileName(fileName);
                
                // 如果无法从文件名解析日期，跳过该文件
                if (!fileDate.HasValue)
                {
                    continue;
                }

                // 将文件日期的时间部分也设置为 00:00:00 进行比较
                var fileDateOnly = fileDate.Value.Date;
                if (fileDateOnly < cutoffDate)
                {
                    try
                    {
                        File.Delete(filePath);
                        deletedCount++;
                    }
                    catch (Exception ex)
                    {
                        logger.LogWarning(ex, "删除过期日志文件失败: {FilePath}", filePath);
                    }
                }
            }

            // 删除空的月份目录
            var monthDirs = Directory.GetDirectories(logDirectory)
                .Where(d => YearMonthDirectoryRegex().IsMatch(Path.GetFileName(d)));

            foreach (var monthDir in monthDirs)
            {
                if (!Directory.EnumerateFileSystemEntries(monthDir).Any())
                {
                    try
                    {
                        Directory.Delete(monthDir);
                    }
                    catch (Exception ex)
                    {
                        logger.LogWarning(ex, "删除空目录失败: {MonthDir}", monthDir);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "清理过期日志文件时发生错误");
            throw;
        }

        return Task.FromResult(deletedCount);
    }

    /// <summary>
    /// 执行压缩任务（压缩旧文件）
    /// </summary>
    public async Task<int> CompressOldFilesAsync()
    {
        var compressAfterDays = logManagementOptions.Value.SystemLog.CompressAfterDays;
        // cutoffDate 的时间部分设置为 00:00:00
        var cutoffDate = DateTime.Now.Date.AddDays(-compressAfterDays);
        var compressedCount = 0;

        if (!Directory.Exists(logDirectory))
        {
            return 0;
        }

        try
        {
            var allFiles = Directory.GetFiles(logDirectory, "*", SearchOption.AllDirectories)
                .Where(f => !f.EndsWith(".zip", StringComparison.OrdinalIgnoreCase));

            foreach (var filePath in allFiles)
            {
                var fileName = Path.GetFileName(filePath);
                // 使用 ParseDateFromFileName 获取文件日期
                var fileDate = ParseDateFromFileName(fileName);
                
                // 如果无法从文件名解析日期，跳过该文件
                if (!fileDate.HasValue)
                {
                    continue;
                }

                // 将文件日期的时间部分也设置为 00:00:00 进行比较
                var fileDateOnly = fileDate.Value.Date;
                if (fileDateOnly < cutoffDate)
                {
                    try
                    {
                        var relativePath = Path.GetRelativePath(logDirectory, filePath).Replace('\\', '/');
                        // 后台任务压缩时不保留源文件
                        await CompressLogFileAsync(relativePath, keepSourceFile: false);
                        compressedCount++;
                    }
                    catch (Exception ex)
                    {
                        logger.LogWarning(ex, "压缩旧日志文件失败: {FilePath}", filePath);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "压缩旧日志文件时发生错误");
            throw;
        }

        return compressedCount;
    }

    /// <summary>
    /// 获取完整文件路径（防止路径遍历攻击）
    /// </summary>
    private string GetFullPath(string relativePath)
    {
        // 规范化路径，移除 ".." 等不安全字符
        var normalizedPath = Path.GetFullPath(Path.Combine(logDirectory, relativePath));

        // 确保路径在日志目录内
        if (!normalizedPath.StartsWith(logDirectory, StringComparison.OrdinalIgnoreCase))
        {
            throw new UnauthorizedAccessException("不允许访问日志目录外的文件");
        }

        return normalizedPath;
    }
}