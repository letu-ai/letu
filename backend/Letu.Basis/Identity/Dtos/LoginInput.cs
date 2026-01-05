using System.ComponentModel.DataAnnotations;
using Volo.Abp.Auditing;

namespace Letu.Basis.Identity.Dtos;

public class LoginInput
{
    /// <summary>
    /// 用户名
    /// </summary>
    [Required]
    [StringLength(32)]
    public required string UserName { get; set; }

    /// <summary>
    /// 密码
    /// </summary>
    [DisableAuditing]
    [Required]
    [StringLength(32)]
    public required string Password { get; set; }

    /// <summary>
    /// 设备ID,设备唯一ID(手机 IMEI/OAID、Web指纹、PC主板串号等)
    /// </summary>
    [StringLength(50)]
    public string DeviceId { get; set; } = string.Empty;

    /// <summary>
    /// 设备友好名(如: iPhone 15、MacBookPro、Chrome 120)
    /// </summary>
    [StringLength(50)]
    public string? DeviceName { get; set; }

    /// <summary>
    /// 客户端类型
    /// </summary>
    public ClientType ClientType { get; set; } = ClientType.Other;

    /// <summary>
    /// 应用版本号
    /// </summary>
    [StringLength(20)]
    public string? AppVersion { get; set; }

}