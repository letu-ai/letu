namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 重命名文件输入
/// </summary>
public class RenameFileInput
{
    /// <summary>
    /// 文件ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 新名称（包含扩展名）
    /// </summary>
    public required string NewName { get; set; }
}

