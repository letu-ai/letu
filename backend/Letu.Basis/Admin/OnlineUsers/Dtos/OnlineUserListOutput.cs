using Letu.Basis.Identity;
using System.Text.Json.Serialization;

namespace Letu.Basis.Admin.OnlineUsers.Dtos;

public class OnlineUserListOutput
{
    /// <summary>
    /// 会话ID
    /// </summary>
    public Guid SessionId { get; set; }

    public Guid UserId { get; set; }

    /// <summary>
    /// 账号
    /// </summary>
    public string? UserName { get; set; }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public ClientType ClientType { get; set; }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public LoginChannel LoginChannel { get; set; }

    public string? IpAddress { get; set; }

    /// <summary>
    /// 登录地址
    /// </summary>
    public string? Geo { get; set; }

    public string? DeviceName { get; set; }

    /// <summary>
    /// 浏览器
    /// </summary>
    public string? UserAgent { get; set; }

    public string? AppVersion { get; set; }

    public DateTime LastActiveTime { get; set; }

    public DateTime CreationTime { get; set; }

}