using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class DictionaryUpdateInput
{
    /// <summary>
    /// 字典显示名称
    /// </summary>
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