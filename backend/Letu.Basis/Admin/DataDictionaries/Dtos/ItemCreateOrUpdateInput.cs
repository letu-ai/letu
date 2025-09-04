using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class ItemCreateOrUpdateInput
{
    /// <summary>
    /// 字典值
    /// </summary>
    [MaxLength(256)]
    public required string Value { get; set; }

    /// <summary>
    /// 显示文本
    /// </summary>
    [MaxLength(128)]
    public string? Label { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    [MaxLength(512)]
    public string? Remark { get; set; }

    /// <summary>
    /// 排序值
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 是否开启
    /// </summary>
    [Required]
    public bool IsEnabled { get; set; }
}