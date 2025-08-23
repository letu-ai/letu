namespace Letu.Core.Applications;


public class TreeSelectOption<T> where T : TreeSelectOption<T>
{
    public required string Key { get; set; }

    public required string Value { get; set; }

    public string? Title { get; set; }

    public string? Parent;

    /// <summary>
    /// 子集
    /// </summary>
    public virtual List<T>? Children { get; set; }


}


public class TreeSelectOption : TreeSelectOption<TreeSelectOption>
{
}