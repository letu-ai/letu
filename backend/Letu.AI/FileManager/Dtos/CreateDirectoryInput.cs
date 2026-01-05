namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 创建目录输入
/// </summary>
public class CreateDirectoryInput
{
    public string Name { get; set; } = string.Empty;
    public string Path { get; set; } = string.Empty;
    public Guid? ParentId { get; set; }
}



