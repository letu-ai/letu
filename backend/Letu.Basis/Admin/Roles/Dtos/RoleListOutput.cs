namespace Letu.Basis.Admin.Roles.Dtos;
public class RoleListOutput
{
    /// <summary>
    /// 角色ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 角色名
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    public string? Remark { get; set; }

    /// <summary>
    /// 是否为默认角色
    /// </summary>
    public bool IsDefault { get; set; }

    /// <summary>
    /// 用户可以查看其他用户的公共角色。一些特殊角色如“超级管理员”不允许被设置为公共角色。
    /// </summary>
    public bool IsPublic { get; set; }

    /// <summary>
    /// 是否启用
    /// </summary>
    public bool IsEnabled { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    public DateTime CreationTime { get; set; }
}