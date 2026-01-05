using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.AI.FileManager;

/// <summary>
/// 文件管理 - 文件表
/// </summary>
[Table(Name = "ai_file")]
public class FileEntity : AuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 文件名（存储时使用的文件名）
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string Name { get; set; }

    /// <summary>
    /// 原始文件名
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string OriginalName { get; set; }

    /// <summary>
    /// 文件存储路径（相对路径）
    /// </summary>
    [Column(IsNullable = false, StringLength = 512)]
    public required string Path { get; set; }

    /// <summary>
    /// 所属目录ID（null表示根目录）
    /// </summary>
    public Guid? DirectoryId { get; set; }

    /// <summary>
    /// 所属目录
    /// </summary>
    [Navigate(nameof(DirectoryId))]
    public DirectoryEntity? Directory { get; set; }

    /// <summary>
    /// 文件类型
    /// </summary>
    [Column(IsNullable = false)]
    public FileType Type { get; set; }

    /// <summary>
    /// MIME类型
    /// </summary>
    [Column(IsNullable = false, StringLength = 128)]
    public required string MimeType { get; set; }

    /// <summary>
    /// 文件大小（字节）
    /// </summary>
    [Column(IsNullable = false)]
    public long Size { get; set; }
}

