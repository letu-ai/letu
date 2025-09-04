namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class ItemListOutput
{
    /// <summary>
    /// 字典ID
    /// </summary>
    public Guid Id { get; set; }

    public Guid DictionaryName{ get; set; }

    /// <summary>
    /// 字典值
    /// </summary>
    public required string Value { get; set; }

    /// <summary>
    /// 显示文本
    /// </summary>
    public string? Label { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    public string? Remark { get; set; }

    /// <summary>
    /// 排序值
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 是否开启
    /// </summary>
    public bool IsEnabled { get; set; }

    public DateTime CreationTime { get; set; }
}