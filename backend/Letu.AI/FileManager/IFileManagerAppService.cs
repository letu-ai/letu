using Letu.AI.FileManager.Dtos;

namespace Letu.AI.FileManager;

/// <summary>
/// 文件处理服务
/// </summary>
public interface IFileManagerAppService
{
    /// <summary>
    /// 获取目录列表
    /// </summary>
    Task<List<DirectoryEntity>> GetDirectoriesAsync(Guid? parentId);

    /// <summary>
    /// 创建目录
    /// </summary>
    Task<DirectoryEntity> CreateDirectoryAsync(CreateDirectoryInput input);

    /// <summary>
    /// 获取文件列表
    /// </summary>
    Task<List<FileEntity>> GetFilesAsync(Guid? directoryId);

    /// <summary>
    /// 上传文件
    /// </summary>
    Task<List<FileEntity>> UploadFilesAsync(UploadFilesInput input);

    /// <summary>
    /// 下载文件
    /// </summary>
    Task<(Stream stream, string fileName, string contentType)> DownloadFileAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// 下载缩略图
    /// </summary>
    Task<(Stream stream, string fileName, string contentType)> DownloadThumbnailAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// 提取 PDF 文本
    /// </summary>
    Task<string> ExtractPdfTextAsync(string filePath);

    /// <summary>
    /// 读取 Excel 文件
    /// </summary>
    Task<Dictionary<string, List<Dictionary<string, object>>>> ReadExcelAsync(string filePath);

    /// <summary>
    /// 提取 Word 文档文本
    /// </summary>
    Task<string> ExtractWordTextAsync(string filePath);

    /// <summary>
    /// 删除目录
    /// </summary>
    Task DeleteDirectoryAsync(Guid id);

    /// <summary>
    /// 删除文件
    /// </summary>
    Task DeleteFileAsync(Guid id);

    /// <summary>
    /// 重命名目录
    /// </summary>
    Task<DirectoryEntity> RenameDirectoryAsync(Dtos.RenameDirectoryInput input);

    /// <summary>
    /// 重命名文件
    /// </summary>
    Task<FileEntity> RenameFileAsync(Dtos.RenameFileInput input);

    /// <summary>
    /// 移动目录
    /// </summary>
    Task<DirectoryEntity> MoveDirectoryAsync(Dtos.MoveDirectoryInput input);

    /// <summary>
    /// 移动文件
    /// </summary>
    Task<FileEntity> MoveFileAsync(Dtos.MoveFileInput input);
}

