namespace Letu.AI.FileManager.Dtos;

/// <summary>
/// 移动文件输入
/// </summary>
public class MoveFileInput
{
    /// <summary>
    /// 文件ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 目标目录ID（null表示移动到根目录）
    /// </summary>
    public Guid? TargetDirectoryId { get; set; }
}

