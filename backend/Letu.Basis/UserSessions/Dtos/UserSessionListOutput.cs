using Letu.Basis.Identity;
using System.Text.Json.Serialization;

namespace Letu.Basis.UserSessions.Dtos;

/// <summary>
/// 用户会话DTO
/// </summary>
public class UserSessionListOutput
{
    /// <summary>
    /// 会话ID
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
    /// 客户端类型
    /// </summary>
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public ClientType ClientType { get; set; }

    /// <summary>
    /// IP地址
    /// </summary>
    public string? IpAddress { get; set; }

    /// <summary>
    /// 登录地理位置
    /// </summary>
    public string? Geo { get; set; }

    /// <summary>
    /// 用户代理
    /// </summary>
    public string? UserAgent { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    public string AppVersion { get; set; } = string.Empty;

    /// <summary>
    /// 设备ID
    /// </summary>
    public string DeviceId { get; set; } = string.Empty;

    /// <summary>
    /// 设备名称
    /// </summary>
    public string? DeviceName { get; set; }

    /// <summary>
    /// 登录渠道
    /// </summary>
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public LoginChannel LoginChannel { get; set; }

    /// <summary>
    /// 登录时间
    /// </summary>
    public DateTime LoginTime { get; set; }

    /// <summary>
    /// 最后活跃时间
    /// </summary>
    public DateTime LastActiveTime { get; set; }

    /// <summary>
    /// 过期时间
    /// </summary>
    public DateTime? ExpireTime { get; set; }

    /// <summary>
    /// 会话状态
    /// </summary>
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public SessionStatus SessionStatus { get; set; }

    /// <summary>
    /// 创建时间
    /// </summary>
    public DateTime CreationTime { get; set; }
}
