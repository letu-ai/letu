using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Menus.Dtos;

public class NavigationMenuDto
{
    /// <summary>
    /// 菜单ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 父级ID
    /// </summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// 显示标题/名称
    /// </summary>
    [NotNull]
    public string? Title { get; set; }

    /// <summary>
    /// 图标
    /// </summary>
    public string? Icon { get; set; }

    /// <summary>
    /// 路由/地址
    /// </summary>
    public string? Path { get; set; }

    public int Sort { get; set; }

    /// <summary>
    /// 是否外链
    /// </summary>
    public bool IsExternal { get; set; }
}