using Letu.Basis.Identity;
using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.UserSessions.Dtos;

/// <summary>
/// 用户会话创建输入参数
/// </summary>
public class UserSessionCreateInput
{
    /// <summary>
    /// 关联用户表主键ID，非空
    /// </summary>
    [Required]
    public required Guid UserId { get; set; }

    /// <summary>
    /// 客户端类型
    /// </summary>
    [Required]
    public ClientType ClientType { get; set; }

    /// <summary>
    /// IP地址
    /// </summary>
    public string? IpAddress { get; set; }

    /// <summary>
    /// 登录地理位置（省/市）
    /// </summary>
    public string? Geo { get; set; }

    /// <summary>
    /// 完整 UA，排查异常设备
    /// </summary>
    public string? UserAgent { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    [StringLength(20)]
    public string? AppVersion { get; set; }

    /// <summary>
    /// 设备ID,设备唯一 ID（手机 IMEI/OAID、Web 指纹、PC 主板串号等）
    /// </summary>
    [Required]
    public required string DeviceId { get; set; }

    /// <summary>
    /// 设备友好名（iPhone 15、MacBookPro、Chrome 120）
    /// </summary>
    public string? DeviceName { get; set; }

    /// <summary>
    /// 刷新令牌
    /// </summary>
    [Required]
    [StringLength(512)]
    public required string RefreshToken { get; set; }

    /// <summary>
    /// 登录渠道（账号密码、短信、第三方等）
    /// </summary>
    public LoginChannel LoginChannel { get; set; }

    /// <summary>
    /// 过期时间
    /// </summary>
    public DateTime? ExpireTime { get; set; }
}
