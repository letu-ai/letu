namespace Letu.Basis.UserSessions;

/// <summary>
/// 会话清理配置选项
/// </summary>
public class UserSessionCleanupOptions
{
    /// <summary>
    /// 清理计划Cron表达式,默认每天凌晨3点
    /// </summary>
    public string CleanupScheduleCron { get; set; } = "0 3 * * *";

    /// <summary>
    /// Inactive会话保留天数,默认30天
    /// </summary>
    public int InactiveRetentionDays { get; set; } = 30;
}
