using Letu.Basis.Identity;

namespace Letu.Basis.Admin.UserDevices.Dtos;

/// <summary>
/// 用户设备列表输出
/// </summary>
public class UserDeviceListOutput
{
    /// <summary>
    /// 设备ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// 用户名
    /// </summary>
    public string? UserName { get; set; }

    /// <summary>
    /// 用户昵称
    /// </summary>
    public string? UserNickName { get; set; }

    /// <summary>
    /// 客户端类型
    /// </summary>
    public ClientType ClientType { get; set; }

    /// <summary>
    /// 应用包名
    /// </summary>
    public string? PackageName { get; set; }

    /// <summary>
    /// 登录设备ID
    /// </summary>
    public string? DeviceId { get; set; }

    /// <summary>
    /// 设备友好名
    /// </summary>
    public string? DeviceName { get; set; }

    /// <summary>
    /// 推送设备ID
    /// </summary>
    public string? PushDeviceId { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    public string? AppVersion { get; set; }

    /// <summary>
    /// 最后活跃时间
    /// </summary>
    public DateTime LastActiveTime { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    public DateTime CreationTime { get; set; }
}
