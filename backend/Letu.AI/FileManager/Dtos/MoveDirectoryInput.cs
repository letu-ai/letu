namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 移动目录输入
/// </summary>
public class MoveDirectoryInput
{
    /// <summary>
    /// 目录ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 目标父目录ID（null表示移动到根目录）
    /// </summary>
    public Guid? TargetParentId { get; set; }
}

