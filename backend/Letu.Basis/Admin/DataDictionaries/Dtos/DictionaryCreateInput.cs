using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class DictionaryCreateInput
{
    /// <summary>
    /// 字典名称
    /// </summary>
    [Required]
    [MaxLength(128)]
    [RegularExpression(@"^[a-zA-Z0-9_-]+$")]
    public required string Name { get; set; }

    /// <summary>
    /// 字典显示名称
    /// </summary>
    [Required]
    [MaxLength(128)]
    public required string DisplayName { get; set; }

    /// <summary>
    /// 是否开启
    /// </summary>
    public bool IsEnabled { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    [MaxLength(512)]
    public string? Remark { get; set; }
}