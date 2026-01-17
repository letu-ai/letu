using System.ComponentModel.DataAnnotations;
using Letu.Basis.Identity;

namespace Letu.Basis.Admin.UserDevices.Dtos;

/// <summary>
/// 保存用户设备信息输入
/// </summary>
public class SaveUserDeviceInput
{
    /// <summary>
    /// 应用包名
    /// </summary>
    [Required(ErrorMessage = "应用包名不能为空")]
    [StringLength(256, ErrorMessage = "应用包名长度不能超过256个字符")]
    public required string PackageName { get; set; }

    /// <summary>
    /// 登录设备ID
    /// </summary>
    [Required(ErrorMessage = "设备ID不能为空")]
    [StringLength(50, ErrorMessage = "设备ID长度不能超过50个字符")]
    public required string DeviceId { get; set; }

    /// <summary>
    /// 设备友好名
    /// </summary>
    [StringLength(50, ErrorMessage = "设备名称长度不能超过50个字符")]
    [Required(ErrorMessage = "设备名称不能为空")]
    public required string DeviceName { get; set; }

    /// <summary>
    /// 客户端类型
    /// </summary>
    [Required(ErrorMessage = "客户端类型不能为空")]
    public ClientType ClientType { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    [Required(ErrorMessage = "应用版本号不能为空")]
    [StringLength(20, ErrorMessage = "应用版本号长度不能超过20个字符")]
    public required string AppVersion { get; set; }

    /// <summary>
    /// 推送设备ID
    /// </summary>
    [StringLength(100, ErrorMessage = "推送设备ID长度不能超过100个字符")]
    [Required(ErrorMessage = "推送设备ID不能为空")]
    public required string PushDeviceId { get; set; }

    /// <summary>
    /// 推送设备Token
    /// </summary>
    [StringLength(512, ErrorMessage = "推送设备Token长度不能超过512个字符")]
    public string? PushDeviceToken { get; set; }
}
