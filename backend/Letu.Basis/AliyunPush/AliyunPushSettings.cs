using System.ComponentModel.DataAnnotations;
using Letu.Core.Security.Serialization;
using Volo.Abp.Auditing;

namespace Letu.Basis.AliyunPush;

public class AliyunPushSettings
{
    [Required(ErrorMessage = "Endpoint不能为空")]
    [StringLength(256, MinimumLength = 1)]
    public string Endpoint { get; set; } = "cloudpush.aliyuncs.com";

    [Required(ErrorMessage = "地域ID不能为空")]
    [StringLength(256, MinimumLength = 1)]
    public string RegionId { get; set; } = "cn-hangzhou";

    [DisableAuditing]
    [EncryptedString]
    [Required(ErrorMessage = "AccessKeyId不能为空")]
    [StringLength(128, MinimumLength = 1)]
    public string? AccessKeyId { get; set; }

    [DisableAuditing]
    [EncryptedString]
    [Required(ErrorMessage = "AccessKeySecret不能为空")]
    [StringLength(128, MinimumLength = 1)]
    public string? AccessKeySecret { get; set; }

    /// <summary>
    /// 应用配置集合
    /// </summary>
    [DisableAuditing]
    [Required(ErrorMessage = "至少需要配置一个应用")]
    [MinLength(1, ErrorMessage = "至少需要配置一个应用")]
    public List<AliyunPushApp> Apps { get; set; } = new();
}

/// <summary>
/// 阿里云推送应用配置
/// </summary>
public class AliyunPushApp
{
    /// <summary>
    /// 应用显示名称
    /// </summary>
    [Required(ErrorMessage = "应用名称不能为空")]
    [StringLength(64, MinimumLength = 1)]
    public string? AppName { get; set; }

    /// <summary>
    /// 应用包名（用于唯一标识应用）
    /// </summary>
    [Required(ErrorMessage = "包名不能为空")]
    [StringLength(256, MinimumLength = 1)]
    public string? PackageName { get; set; }

    /// <summary>
    /// 应用AppKey
    /// </summary>
    [DisableAuditing]
    [EncryptedString]
    [Required(ErrorMessage = "AppKey不能为空")]
    [StringLength(64, MinimumLength = 1)]
    public string? AppKey { get; set; }

    /// <summary>
    /// 应用AppSecret
    /// </summary>
    [DisableAuditing]
    [EncryptedString]
    [Required(ErrorMessage = "AppSecret不能为空")]
    [StringLength(128, MinimumLength = 1)]
    public string? AppSecret { get; set; }
}
