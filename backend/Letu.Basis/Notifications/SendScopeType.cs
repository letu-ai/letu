namespace Letu.Basis.Notifications;

/// <summary>
/// 发送范围类型
/// </summary>
public enum SendScopeType
{
    /// <summary>
    /// 指定用户
    /// </summary>
    SpecificUsers = 1,

    /// <summary>
    /// 按角色
    /// </summary>
    ByRole = 2,

    /// <summary>
    /// 按部门
    /// </summary>
    ByDepartment = 3,

    /// <summary>
    /// 按职位
    /// </summary>
    ByPosition = 4,

    /// <summary>
    /// 全体用户
    /// </summary>
    AllUsers = 5,

    /// <summary>
    /// 指定设备（根据设备ID推送）
    /// </summary>
    SpecificDevices = 6,

    /// <summary>
    /// 按客户端类型（Android/iOS/Web等）
    /// </summary>
    ByClientType = 7
}