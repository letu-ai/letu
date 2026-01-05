using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity;

namespace Letu.Basis.UserSessions;

[Table(Name = "sys_user_session")]
[Index("uk_user_session", "UserId")]
[Index("idx_user_session_expire_time", "ExpireTime")]
[Index("idx_user_session_last_active_time", "LastActiveTime")]
[Index("idx_user_session_refresh_token", "RefreshToken")]
public class UserSession : AuditedEntity<Guid>, IMultiTenant
{
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 关联用户表主键ID，非空
    /// </summary>
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    [Navigate(nameof(UserId))]
    public User? User { get; set; }

    public SessionStatus Status { get; set; }

    public ClientType ClientType { get; set; }

    /// <summary>
    /// 登录渠道（账号密码、短信、第三方等）
    /// </summary>
    [Column(IsNullable = false, StringLength = 20)]
    public LoginChannel LoginChannel { get; set; }

    public DateTime LastActiveTime { get; set; }
    public DateTime? ExpireTime { get; set; }

    /// <summary>
    /// 刷新令牌
    /// </summary>
    [Column(IsNullable = false, StringLength = 512)]
    public required string RefreshToken { get; set; }
    
    /// <summary>
    /// IP地址
    /// </summary>
    [Column( StringLength = 32)]
    public string? IpAddress { get; set; }

    /// <summary>
    /// 登录地理位置（省/市）
    /// </summary>
    [Column( StringLength = 32)]
    public string? Geo { get; set; }

    /// <summary>
    /// 完整 UA，排查异常设备
    /// </summary>
    [Column( StringLength = 512)]
    public string? UserAgent { get; set; }

    /// <summary>
    /// 应用版本号
    /// </summary>
    [Column( StringLength = 20)]
    public string? AppVersion { get; set; }

    /// <summary>
    /// 设备ID,设备唯一 ID（手机 IMEI/OAID、Web 指纹、PC 主板串号等）
    /// </summary>
    [Column( StringLength = 50)]
    public required string DeviceId { get; set; }

    /// <summary>
    /// 设备友好名（iPhone 15、MacBookPro、Chrome 120）
    /// </summary>
    [Column( StringLength = 50)]
    public string? DeviceName { get; set; }
}
