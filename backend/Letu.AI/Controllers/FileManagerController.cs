using Letu.AI.FileManager;
using Letu.AI.FileManager.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.AI.Controllers;

/// <summary>
/// 文件管理 API 控制器
/// </summary>
[ApiController]
[Route("api/ai/file-manager")]
[Authorize]
public class FileManagerController : AbpControllerBase
{
    private readonly IFileManagerAppService fileManagerAppService;
    private readonly Volo.Abp.BlobStoring.IBlobContainer<FileBlobContainer> fileBlobContainer;

    public FileManagerController(
        IFileManagerAppService fileManagerAppService,
        Volo.Abp.BlobStoring.IBlobContainer<FileBlobContainer> fileBlobContainer)
    {
        this.fileManagerAppService = fileManagerAppService;
        this.fileBlobContainer = fileBlobContainer;
    }

    /// <summary>
    /// 获取目录列表
    /// </summary>
    [HttpGet("directories")]
    public async Task<ActionResult<List<DirectoryEntity>>> GetDirectoriesAsync([FromQuery] Guid? parentId)
    {
        var directories = await fileManagerAppService.GetDirectoriesAsync(parentId);
        return Ok(directories);
    }

    /// <summary>
    /// 创建目录
    /// </summary>
    [HttpPost("directories")]
    public async Task<ActionResult<DirectoryEntity>> CreateDirectoryAsync([FromBody] CreateDirectoryInput input)
    {
        var directory = await fileManagerAppService.CreateDirectoryAsync(input);
        return Ok(directory);
    }

    /// <summary>
    /// 删除目录
    /// </summary>
    [HttpDelete("directories/{id}")]
    public async Task<IActionResult> DeleteDirectoryAsync(Guid id)
    {
        await fileManagerAppService.DeleteDirectoryAsync(id);
        return Ok();
    }

    /// <summary>
    /// 重命名目录
    /// </summary>
    [HttpPut("directories/rename")]
    public async Task<ActionResult<DirectoryEntity>> RenameDirectoryAsync([FromBody] RenameDirectoryInput input)
    {
        var directory = await fileManagerAppService.RenameDirectoryAsync(input);
        return Ok(directory);
    }

    /// <summary>
    /// 移动目录
    /// </summary>
    [HttpPut("directories/move")]
    public async Task<ActionResult<DirectoryEntity>> MoveDirectoryAsync([FromBody] MoveDirectoryInput input)
    {
        var directory = await fileManagerAppService.MoveDirectoryAsync(input);
        return Ok(directory);
    }
    
    /// <summary>
    /// 获取文件列表
    /// </summary>
    [HttpGet("files")]
    public async Task<ActionResult<List<FileEntity>>> GetFilesAsync([FromQuery] Guid? directoryId)
    {
        var files = await fileManagerAppService.GetFilesAsync(directoryId);
        return Ok(files);
    }

    /// <summary>
    /// 上传文件
    /// </summary>
    [HttpPost("files")]
    public async Task<ActionResult<List<FileEntity>>> UploadFileAsync([FromForm] UploadFilesInput input)
    {
        var uploadedFiles = await fileManagerAppService.UploadFilesAsync(input);
        return Ok(uploadedFiles);
    }

    /// <summary>
    /// 下载文件
    /// </summary>
    [HttpGet("files/{id}")]
    public async Task<IActionResult> DownloadFileAsync(Guid id, CancellationToken cancellationToken)
    {
        var (stream, fileName, contentType) = await fileManagerAppService.DownloadFileAsync(id, cancellationToken);
        return File(stream, contentType, fileName);
    }

    /// <summary>
    /// 下载缩略图
    /// </summary>
    [HttpGet("files/{id}/thumbnail")]
    public async Task<IActionResult> DownloadThumbnailAsync(Guid id, CancellationToken cancellationToken)
    {
        var (stream, fileName, contentType) = await fileManagerAppService.DownloadThumbnailAsync(id, cancellationToken);
        return File(stream, contentType, fileName);
    }

    /// <summary>
    /// 删除文件
    /// </summary>
    [HttpDelete("files/{id}")]
    public async Task<IActionResult> DeleteFileAsync(Guid id)
    {
        await fileManagerAppService.DeleteFileAsync(id);
        return Ok();
    }

    /// <summary>
    /// 重命名文件
    /// </summary>
    [HttpPut("files/rename")]
    public async Task<ActionResult<FileEntity>> RenameFileAsync([FromBody] RenameFileInput input)
    {
        var file = await fileManagerAppService.RenameFileAsync(input);
        return Ok(file);
    }


    /// <summary>
    /// 移动文件
    /// </summary>
    [HttpPut("files/move")]
    public async Task<ActionResult<FileEntity>> MoveFileAsync([FromBody] MoveFileInput input)
    {
        var file = await fileManagerAppService.MoveFileAsync(input);
        return Ok(file);
    }
}

