namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 重命名目录输入
/// </summary>
public class RenameDirectoryInput
{
    /// <summary>
    /// 目录ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 新名称
    /// </summary>
    public required string NewName { get; set; }
}

