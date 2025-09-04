namespace Letu.Core.Applications;

public class SelectOption
{
    /// <summary>
    /// 显示文本
    /// </summary>

    public required string Label { get; set; }

    /// <summary>
    /// 实际值
    /// </summary>
    public required string Value { get; set; }

    /// <summary>
    /// true表示被禁用的项
    /// </summary>
    public bool Disabled { get; set; }
}