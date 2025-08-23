using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Menus.Dtos;

public class MenuItemListOutput
{
    /// <summary>
    /// 菜单ID
    /// </summary>
    public Guid Id { get; set; }

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

    /// <summary>
    /// 功能类型
    /// </summary>
    public MenuType MenuType { get; set; }

    /// <summary>
    /// 父级ID
    /// </summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 隐藏
    /// </summary>
    public bool Display { get; set; }

    /// <summary>
    /// 子集
    /// </summary>
    public List<MenuItemListOutput>? Children { get; set; }

    /// <summary>
    /// 是否外链
    /// </summary>
    public bool IsExternal { get; set; }

    /// <summary>
    /// 所需权限
    /// </summary>
    public string[]? Permissions { get; set; }

    /// <summary>
    /// 所需权限显示名称（权限组/权限名）
    /// </summary>
    public string[]? PermissionDisplayNames { get; set; }

    /// <summary>
    /// 功能开关
    /// </summary>
    public string[]? Features { get; set; }

    /// <summary>
    /// 功能开关显示名称
    /// </summary>
    public string[]? FeatureDisplayNames { get; set; }
}
