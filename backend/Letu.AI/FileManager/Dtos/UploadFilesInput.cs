using Microsoft.AspNetCore.Http;

namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 上传文件输入
/// </summary>
public class UploadFilesInput
{
    /// <summary>
    /// 目标目录ID（可选，为空时上传到根目录）
    /// </summary>
    public Guid? DirectoryId { get; set; }

    /// <summary>
    /// 上传的文件列表
    /// </summary>
    public List<IFormFile> Files { get; set; } = [];
}
