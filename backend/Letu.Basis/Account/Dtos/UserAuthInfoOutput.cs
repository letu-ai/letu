using Letu.Shared.Models;

namespace Letu.Basis.Account.Dtos;

public class UserAuthInfoOutput
{
    /// <summary>
    /// 用户信息
    /// </summary>
    public UserInfoOutput User { get; set; } = null!;

    /// <summary>
    /// 权限信息
    /// </summary>
    public string[] Permissions { get; set; } = null!;

    /// <summary>
    /// 菜单信息
    /// </summary>
    public List<FrontendMenu> Menus { get; set; } = null!;
}