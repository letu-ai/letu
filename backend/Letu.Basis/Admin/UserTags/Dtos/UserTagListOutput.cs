namespace Letu.Basis.Admin.UserTags.Dtos;

public class UserTagListOutput
{
    /// <summary>
    /// 标签ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 标签名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 标签颜色
    /// </summary>
    public string? Color { get; set; }

    /// <summary>
    /// 排序号
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 使用该标签的用户数量
    /// </summary>
    public int UserCount { get; set; }
}