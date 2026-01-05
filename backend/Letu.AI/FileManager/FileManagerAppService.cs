using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Letu.AI.FileManager.Dtos;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using OfficeOpenXml;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using System.Text;
using UglyToad.PdfPig;
using UglyToad.PdfPig.Content;
using Volo.Abp.BlobStoring;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Users;

namespace Letu.AI.FileManager;

/// <summary>
/// 文件处理服务
/// </summary>
public class FileManagerAppService : AIAppService, IFileManagerAppService
{
    private readonly IBlobContainer<FileBlobContainer> fileBlobContainer;
    private readonly IFreeSqlRepository<DirectoryEntity> directoryRepository;
    private readonly IFreeSqlRepository<FileEntity> fileRepository;

    public FileManagerAppService(
        IBlobContainer<FileBlobContainer> fileBlobContainer,
        IFreeSqlRepository<DirectoryEntity> directoryRepository,
        IFreeSqlRepository<FileEntity> fileRepository)
    {
        this.fileBlobContainer = fileBlobContainer;
        this.directoryRepository = directoryRepository;
        this.fileRepository = fileRepository;
    }

    /// <summary>
    /// 获取目录列表
    /// </summary>
    public async Task<List<DirectoryEntity>> GetDirectoriesAsync(Guid? parentId)
    {
        // 如果指定了 parentId，只返回该父目录的直接子目录
        if (parentId.HasValue)
        {
            return await directoryRepository.Select
                .Where(x => x.ParentId == parentId)
                .OrderBy(x => x.Name)
                .ToListAsync();
        }

        // 如果 parentId 为 null，返回完整的树形结构（所有根目录及其递归子目录）
        var allDirectories = await directoryRepository.Select
            .OrderBy(x => x.Name)
            .ToListAsync();

        // 构建树形结构
        return BuildDirectoryTree(allDirectories, null);
    }

    /// <summary>
    /// 构建目录树形结构
    /// </summary>
    private List<DirectoryEntity> BuildDirectoryTree(List<DirectoryEntity> allDirectories, Guid? parentId)
    {
        var result = new List<DirectoryEntity>();

        foreach (var directory in allDirectories.Where(d => d.ParentId == parentId))
        {
            // 递归加载子目录
            directory.Children = BuildDirectoryTree(allDirectories, directory.Id);
            result.Add(directory);
        }

        return result;
    }

    /// <summary>
    /// 创建目录
    /// </summary>
    public async Task<DirectoryEntity> CreateDirectoryAsync(CreateDirectoryInput input)
    {
        // 检查同一父目录下是否已存在同名目录
        var exists = await directoryRepository.Select
            .Where(x => x.ParentId == input.ParentId && x.Name == input.Name)
            .AnyAsync();

        if (exists)
        {
            throw HttpFriendlyException.BadRequest($"目录名称 '{input.Name}' 已存在");
        }

        // 构建目录路径
        var path = await BuildDirectoryPath(input.ParentId, input.Name);

        var directory = new DirectoryEntity
        {
            Name = input.Name,
            Path = path,
            ParentId = input.ParentId
        };

        await directoryRepository.InsertAsync(directory);
        return directory;
    }

    /// <summary>
    /// 获取文件列表
    /// </summary>
    public async Task<List<FileEntity>> GetFilesAsync(Guid? directoryId)
    {
        return await fileRepository.Select
            .Where(x => x.DirectoryId == directoryId)
            .ToListAsync();
    }

    /// <summary>
    /// 上传文件
    /// </summary>
    public async Task<List<FileEntity>> UploadFilesAsync(UploadFilesInput input)
    {
        var files = input.Files;
        if (files == null || files.Count == 0)
        {
            throw HttpFriendlyException.BadRequest("文件不能为空");
        }

        var uploadedFiles = new List<FileEntity>();

        foreach (var file in files)
        {
            if (file == null || file.Length == 0)
            {
                continue;
            }

            var fileId = GuidGenerator.Create();
            var fileExtension = Path.GetExtension(file.FileName);
            var storedFileName = $"{fileId}{fileExtension}";
            var filePath = $"files/{storedFileName}";

            // 获取文件大小
            var fileSize = file.Length;

            // 打开文件流并保存到 Blob 存储
            using var stream = file.OpenReadStream();
            await fileBlobContainer.SaveAsync(filePath, stream, true);

            // 根据扩展名确定文件类型和 MIME 类型（优先使用扩展名，因为浏览器可能发送错误的 MIME 类型）
            var (fileType, mimeType) = GetFileTypeAndMimeType(fileExtension, file.ContentType);

            // 如果是图片类型，生成缩略图
            if (fileType == FileType.Image)
            {
                try
                {
                    await GenerateThumbnailAsync(file, filePath);
                }
                catch (Exception ex)
                {
                    // 如果缩略图生成失败，记录日志但不影响文件上传
                    Logger?.LogWarning(ex, "生成缩略图失败: {FilePath}", filePath);
                }
            }

            // 创建文件记录
            var fileEntity = new FileEntity
            {
                Name = storedFileName,
                OriginalName = file.FileName,
                Path = filePath,
                DirectoryId = input.DirectoryId,
                Type = fileType,
                MimeType = mimeType,
                Size = fileSize
            };

            await fileRepository.InsertAsync(fileEntity);
            uploadedFiles.Add(fileEntity);
        }

        if (uploadedFiles.Count == 0)
        {
            throw HttpFriendlyException.BadRequest("没有有效的文件");
        }

        return uploadedFiles;
    }

    /// <summary>
    /// 下载文件
    /// </summary>
    public async Task<(Stream stream, string fileName, string contentType)> DownloadFileAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var file = await fileRepository.Select
            .Where(x => x.Id == id)
            .FirstAsync(cancellationToken)
            ?? throw new EntityNotFoundException();

        var stream = await fileBlobContainer.GetAsync(file.Path, cancellationToken);
        return (stream, file.OriginalName, file.MimeType);
    }

    /// <summary>
    /// 下载缩略图
    /// </summary>
    public async Task<(Stream stream, string fileName, string contentType)> DownloadThumbnailAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var file = await fileRepository.Select
            .Where(x => x.Id == id)
            .FirstAsync(cancellationToken)
            ?? throw new EntityNotFoundException();

        if (file.Type != FileType.Image)
        {
            throw HttpFriendlyException.BadRequest("该文件不是图片类型，无法获取缩略图");
        }

        var thumbnailPath = GetThumbnailPath(file.Path);

        try
        {
            var stream = await fileBlobContainer.GetAsync(thumbnailPath, cancellationToken);
            return (stream, $"{Path.GetFileNameWithoutExtension(file.OriginalName)}_thumb.png", "image/png");
        }
        catch
        {
            throw HttpFriendlyException.NotFound("缩略图不存在");
        }
    }

    /// <summary>
    /// 根据文件扩展名获取文件类型和 MIME 类型
    /// </summary>
    /// <param name="extension">文件扩展名（包含点号，如 .jpg）</param>
    /// <param name="browserMimeType">浏览器提供的 MIME 类型（可选，用于未知类型的回退）</param>
    /// <returns>文件类型和 MIME 类型的元组</returns>
    private static (FileType fileType, string mimeType) GetFileTypeAndMimeType(string extension, string? browserMimeType = null)
    {
        return extension.ToLowerInvariant() switch
        {
            ".jpg" or ".jpeg" => (FileType.Image, "image/jpeg"),
            ".png" => (FileType.Image, "image/png"),
            ".gif" => (FileType.Image, "image/gif"),
            ".bmp" => (FileType.Image, "image/bmp"),
            ".webp" => (FileType.Image, "image/webp"),
            ".svg" => (FileType.Image, "image/svg+xml"),
            ".pdf" => (FileType.Pdf, "application/pdf"),
            ".doc" => (FileType.Word, "application/msword"),
            ".docx" => (FileType.Word, "application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
            ".xls" => (FileType.Excel, "application/vnd.ms-excel"),
            ".xlsx" => (FileType.Excel, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
            ".txt" => (FileType.Text, "text/plain"),
            _ => (FileType.Other, browserMimeType ?? "application/octet-stream")
        };
    }

    /// <summary>
    /// 提取 PDF 文本
    /// </summary>
    public async Task<string> ExtractPdfTextAsync(string filePath)
    {
        return await Task.Run(() =>
        {
            using var document = PdfDocument.Open(filePath);
            var text = new StringBuilder();

            foreach (Page page in document.GetPages())
            {
                text.AppendLine(page.Text);
            }

            return text.ToString();
        });
    }

    /// <summary>
    /// 读取 Excel 文件
    /// </summary>
    public async Task<Dictionary<string, List<Dictionary<string, object>>>> ReadExcelAsync(string filePath)
    {
        ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
        var result = new Dictionary<string, List<Dictionary<string, object>>>();

        using var package = new ExcelPackage(new FileInfo(filePath));

        foreach (var worksheet in package.Workbook.Worksheets)
        {
            var rows = new List<Dictionary<string, object>>();

            if (worksheet.Dimension != null)
            {
                var headers = new List<string>();
                // 读取表头（第一行）
                for (int col = 1; col <= worksheet.Dimension.End.Column; col++)
                {
                    var header = worksheet.Cells[1, col].Value?.ToString() ?? $"Column{col}";
                    headers.Add(header);
                }

                // 读取数据行
                for (int row = 2; row <= worksheet.Dimension.End.Row; row++)
                {
                    var rowData = new Dictionary<string, object>();
                    for (int col = 1; col <= headers.Count; col++)
                    {
                        var value = worksheet.Cells[row, col].Value;
                        rowData[headers[col - 1]] = value ?? string.Empty;
                    }
                    rows.Add(rowData);
                }
            }

            result[worksheet.Name] = rows;
        }

        return result;
    }

    /// <summary>
    /// 提取 Word 文档文本
    /// </summary>
    public async Task<string> ExtractWordTextAsync(string filePath)
    {
        using var wordDocument = WordprocessingDocument.Open(filePath, false);
        var body = wordDocument.MainDocumentPart?.Document?.Body;

        if (body == null)
        {
            return string.Empty;
        }

        var text = new StringBuilder();

        foreach (var paragraph in body.Elements<Paragraph>())
        {
            var paraText = paragraph.InnerText;
            if (!string.IsNullOrWhiteSpace(paraText))
            {
                text.AppendLine(paraText);
            }
        }

        return text.ToString();
    }

    /// <summary>
    /// 删除目录
    /// </summary>
    public async Task DeleteDirectoryAsync(Guid id)
    {
        var directory = await directoryRepository.Select
            .Where(x => x.Id == id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 检查是否有子目录
        var hasChildren = await directoryRepository.Select
            .Where(x => x.ParentId == id)
            .AnyAsync();

        if (hasChildren)
        {
            throw HttpFriendlyException.BadRequest("目录下存在子目录，无法删除");
        }

        // 检查是否有文件
        var hasFiles = await fileRepository.Select
            .Where(x => x.DirectoryId == id)
            .AnyAsync();

        if (hasFiles)
        {
            throw HttpFriendlyException.BadRequest("目录下存在文件，无法删除");
        }

        await directoryRepository.DeleteAsync(directory);
    }

    /// <summary>
    /// 删除文件
    /// </summary>
    public async Task DeleteFileAsync(Guid id)
    {
        var file = await fileRepository.Select
            .Where(x => x.Id == id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 删除 Blob 存储中的文件
        try
        {
            await fileBlobContainer.DeleteAsync(file.Path);
        }
        catch
        {
            // 如果文件不存在，继续删除数据库记录
        }

        // 如果是图片类型，删除缩略图
        if (file.Type == FileType.Image)
        {
            try
            {
                var thumbnailPath = GetThumbnailPath(file.Path);
                await fileBlobContainer.DeleteAsync(thumbnailPath);
            }
            catch
            {
                // 如果缩略图不存在，继续删除数据库记录
            }
        }

        // 删除数据库记录
        await fileRepository.DeleteAsync(file);
    }

    /// <summary>
    /// 重命名目录
    /// </summary>
    public async Task<DirectoryEntity> RenameDirectoryAsync(Dtos.RenameDirectoryInput input)
    {
        var directory = await directoryRepository.Select
            .Where(x => x.Id == input.Id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 检查新名称是否在同一父目录下已存在
        var exists = await directoryRepository.Select
            .Where(x => x.ParentId == directory.ParentId && x.Name == input.NewName && x.Id != input.Id)
            .AnyAsync();

        if (exists)
        {
            throw HttpFriendlyException.BadRequest($"目录名称 '{input.NewName}' 已存在");
        }

        directory.Name = input.NewName;
        // 更新路径（如果需要，可以根据实际需求调整路径生成逻辑）
        directory.Path = await BuildDirectoryPath(directory.ParentId, input.NewName);

        await directoryRepository.UpdateAsync(directory);
        return directory;
    }

    /// <summary>
    /// 重命名文件
    /// </summary>
    public async Task<FileEntity> RenameFileAsync(Dtos.RenameFileInput input)
    {
        var file = await fileRepository.Select
            .Where(x => x.Id == input.Id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 检查新名称是否在同一目录下已存在
        var exists = await fileRepository.Select
            .Where(x => x.DirectoryId == file.DirectoryId && x.OriginalName == input.NewName && x.Id != input.Id)
            .AnyAsync();

        if (exists)
        {
            throw HttpFriendlyException.BadRequest($"文件名 '{input.NewName}' 已存在");
        }

        file.OriginalName = input.NewName;
        await fileRepository.UpdateAsync(file);
        return file;
    }

    /// <summary>
    /// 移动目录
    /// </summary>
    public async Task<DirectoryEntity> MoveDirectoryAsync(Dtos.MoveDirectoryInput input)
    {
        var directory = await directoryRepository.Select
            .Where(x => x.Id == input.Id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 检查是否移动到自己的子目录（防止循环引用）
        if (input.TargetParentId.HasValue)
        {
            var isDescendant = await IsDescendantDirectoryAsync(input.TargetParentId.Value, input.Id);
            if (isDescendant)
            {
                throw HttpFriendlyException.BadRequest("不能将目录移动到自己的子目录中");
            }
        }

        // 检查目标位置是否已存在同名目录
        var exists = await directoryRepository.Select
            .Where(x => x.ParentId == input.TargetParentId && x.Name == directory.Name && x.Id != input.Id)
            .AnyAsync();

        if (exists)
        {
            throw HttpFriendlyException.BadRequest($"目标位置已存在同名目录 '{directory.Name}'");
        }

        directory.ParentId = input.TargetParentId;
        directory.Path = await BuildDirectoryPath(input.TargetParentId, directory.Name);

        await directoryRepository.UpdateAsync(directory);
        return directory;
    }

    /// <summary>
    /// 移动文件
    /// </summary>
    public async Task<FileEntity> MoveFileAsync(Dtos.MoveFileInput input)
    {
        var file = await fileRepository.Select
            .Where(x => x.Id == input.Id)
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        // 检查目标位置是否已存在同名文件
        var exists = await fileRepository.Select
            .Where(x => x.DirectoryId == input.TargetDirectoryId && x.OriginalName == file.OriginalName && x.Id != input.Id)
            .AnyAsync();

        if (exists)
        {
            throw HttpFriendlyException.BadRequest($"目标位置已存在同名文件 '{file.OriginalName}'");
        }

        file.DirectoryId = input.TargetDirectoryId;
        await fileRepository.UpdateAsync(file);
        return file;
    }

    /// <summary>
    /// 检查目标目录是否是源目录的后代（防止循环引用）
    /// </summary>
    private async Task<bool> IsDescendantDirectoryAsync(Guid targetId, Guid sourceId)
    {
        var currentId = targetId;
        var maxDepth = 100; // 防止无限循环
        var depth = 0;

        while (currentId != sourceId && depth < maxDepth)
        {
            var parent = await directoryRepository.Select
                .Where(x => x.Id == currentId)
                .FirstAsync();

            if (parent == null || parent.ParentId == null)
            {
                return false;
            }

            currentId = parent.ParentId.Value;
            depth++;
        }

        return currentId == sourceId;
    }

    /// <summary>
    /// 构建目录路径
    /// </summary>
    private async Task<string> BuildDirectoryPath(Guid? parentId, string name)
    {
        if (parentId == null)
        {
            return name;
        }

        var pathParts = new List<string> { name };
        var currentId = parentId;
        var maxDepth = 100; // 防止无限循环
        var depth = 0;

        while (currentId.HasValue && depth < maxDepth)
        {
            var parent = await directoryRepository.Select
                .Where(x => x.Id == currentId.Value)
                .FirstAsync();

            if (parent == null)
            {
                break;
            }

            pathParts.Insert(0, parent.Name);
            currentId = parent.ParentId;
            depth++;
        }

        return string.Join("/", pathParts);
    }

    /// <summary>
    /// 生成缩略图
    /// </summary>
    private async Task GenerateThumbnailAsync(IFormFile originalFile, string originalFilePath)
    {
        const int thumbnailSize = 128;

        // 生成缩略图路径：将原文件路径的扩展名替换为 _thumb.png
        var thumbnailPath = GetThumbnailPath(originalFilePath);

        // 读取原始图片
        using var originalStream = originalFile.OpenReadStream();
        using var image = await Image.LoadAsync(originalStream);

        // 计算缩放尺寸，保持宽高比
        var (width, height) = CalculateThumbnailSize(image.Width, image.Height, thumbnailSize);

        // 创建缩略图
        using var thumbnail = image.Clone(ctx => ctx
            .Resize(new ResizeOptions
            {
                Size = new Size(width, height),
                Mode = ResizeMode.Max,
                Sampler = KnownResamplers.Lanczos3
            }));

        // 创建128x128的画布，透明背景（Image<Rgba32>默认就是透明的）
        using var canvas = new Image<Rgba32>(thumbnailSize, thumbnailSize);
        canvas.Mutate(ctx =>
        {
            // 将缩略图居中绘制
            var x = (thumbnailSize - width) / 2;
            var y = (thumbnailSize - height) / 2;
            ctx.DrawImage(thumbnail, new Point(x, y), 1f);
        });

        // 保存缩略图到内存流
        using var thumbnailStream = new MemoryStream();
        await canvas.SaveAsPngAsync(thumbnailStream);
        thumbnailStream.Position = 0;

        // 保存到 Blob 存储
        await fileBlobContainer.SaveAsync(thumbnailPath, thumbnailStream, true);
    }

    /// <summary>
    /// 计算缩略图尺寸，保持宽高比
    /// </summary>
    private static (int width, int height) CalculateThumbnailSize(int originalWidth, int originalHeight, int maxSize)
    {
        if (originalWidth <= maxSize && originalHeight <= maxSize)
        {
            return (originalWidth, originalHeight);
        }

        var ratio = Math.Min((double)maxSize / originalWidth, (double)maxSize / originalHeight);
        return ((int)(originalWidth * ratio), (int)(originalHeight * ratio));
    }

    /// <summary>
    /// 获取缩略图路径
    /// </summary>
    internal static string GetThumbnailPath(string originalPath)
    {
        // 统一使用正斜杠处理路径
        var normalizedPath = originalPath.Replace('\\', '/');

        // 找到最后一个斜杠的位置
        var lastSlashIndex = normalizedPath.LastIndexOf('/');

        if (lastSlashIndex >= 0)
        {
            // 有目录路径：提取目录和文件名
            var directory = normalizedPath.Substring(0, lastSlashIndex);
            var fileName = normalizedPath.Substring(lastSlashIndex + 1);

            // 获取文件名（不含扩展名）
            var lastDotIndex = fileName.LastIndexOf('.');
            var fileNameWithoutExtension = lastDotIndex >= 0
                ? fileName.Substring(0, lastDotIndex)
                : fileName;

            return $"{directory}/{fileNameWithoutExtension}_thumb.png";
        }
        else
        {
            // 没有目录路径：直接处理文件名
            var lastDotIndex = normalizedPath.LastIndexOf('.');
            var fileNameWithoutExtension = lastDotIndex >= 0
                ? normalizedPath.Substring(0, lastDotIndex)
                : normalizedPath;

            return $"{fileNameWithoutExtension}_thumb.png";
        }
    }
}

