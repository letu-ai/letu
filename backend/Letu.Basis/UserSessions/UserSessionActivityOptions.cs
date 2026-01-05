namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话活动时间配置选项
/// </summary>
public class UserSessionActivityOptions
{
    /// <summary>
    /// 批量更新Cron表达式，默认每10分钟执行一次
    /// </summary>
    public string BatchUpdateCronExpression { get; set; } = "0 */10 * * * *";

    /// <summary>
    /// 缓存过期时间（分钟），默认15分钟
    /// </summary>
    public int CacheExpirationMinutes { get; set; } = 15;
}

