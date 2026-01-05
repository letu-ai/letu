using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.UserTags.Dtos;

public class UserTagUpdateInput
{
    /// <summary>
    /// 标签名称
    /// </summary>
    [Required]
    [StringLength(32)]
    public required string Name { get; set; }

    /// <summary>
    /// 标签颜色（Hex格式，如 #1890ff）
    /// </summary>
    [StringLength(16)]
    public string? Color { get; set; }
}