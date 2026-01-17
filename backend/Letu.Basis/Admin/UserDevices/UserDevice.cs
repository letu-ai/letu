using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity;

namespace Letu.Basis.Admin.UserDevices;

/// <summary>
/// 用户设备表 - 用于存储用户的推送设备信息
/// </summary>
[Table(Name = "sys_user_device")]
[Index("uk_user_device", $"{nameof(UserId)},{nameof(DeviceId)},{nameof(PackageName)}", IsUnique = true)]
[Index("idx_user_device_push", $"{nameof(PushDeviceId)},{nameof(PackageName)}")]
public class UserDevice : FullAuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(StringLength = 18)]
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    /// <summary>
    /// 关联用户
    /// </summary>
    [Navigate(nameof(UserId))]
    public User? User { get; set; }

    /// <summary>
    /// 客户端类型
    /// </summary>
    [Column(IsNullable = false)]
    public ClientType ClientType { get; set; }

    /// <summary>
    /// 应用包名(用于区分不同的App)
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string PackageName { get; set; }

    /// <summary>
    /// 登录设备ID(手机IMEI/OAID、Web指纹等)
    /// </summary>
    [Column(IsNullable = false, StringLength = 50)]
    public required string DeviceId { get; set; }

    /// <summary>
    /// 设备友好名(如: iPhone 15、MacBookPro、Chrome 120)
    /// </summary>
    [Column(StringLength = 50)]
    public string? DeviceName { get; set; }

    /// <summary>
    /// 推送服务设备ID(阿里云推送返回的DeviceId)
    /// </summary>
    [Column(StringLength = 100)]
    public string? PushDeviceId { get; set; }

    /// <summary>
    /// 推送设备Token(APNs的DeviceToken等)
    /// </summary>
    [Column(StringLength = 512)]
    public string? PushDeviceToken { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    [Column(StringLength = 20)]
    public string? AppVersion { get; set; }

    /// <summary>
    /// 最后活跃时间
    /// </summary>
    [Column(IsNullable = false)]
    public DateTime LastActiveTime { get; set; }
}
