using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.AI.FileManager;

/// <summary>
/// 文件管理 - 目录表
/// </summary>
[Table(Name = "ai_directory")]
public class DirectoryEntity : AuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 目录名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string Name { get; set; }

    /// <summary>
    /// 目录路径（相对路径，如 "documents/project1"）
    /// </summary>
    [Column(IsNullable = false, StringLength = 512)]
    public required string Path { get; set; }

    /// <summary>
    /// 父目录ID（支持嵌套目录）
    /// </summary>
    [Column(IsNullable = true)]
    public Guid? ParentId { get; set; }

    /// <summary>
    /// 父目录
    /// </summary>
    [Navigate(nameof(ParentId))]
    public DirectoryEntity? Parent { get; set; }

    /// <summary>
    /// 子目录
    /// </summary>
    [Navigate(nameof(ParentId))]
    public ICollection<DirectoryEntity>? Children { get; set; }

    /// <summary>
    /// 目录下的文件
    /// </summary>
    [Navigate(nameof(FileEntity.DirectoryId))]
    public ICollection<FileEntity>? Files { get; set; }
}

