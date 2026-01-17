namespace Letu.Basis.Notifications;

/// <summary>
/// 推送重试配置
/// </summary>
public class PushRetryConfig
{
    /// <summary>
    /// 最大重试次数
    /// </summary>
    public int MaxRetryCount { get; set; } = 3;

    /// <summary>
    /// 重试间隔（分钟）：按重试次数递增
    /// 第1次重试：1分钟后
    /// 第2次重试：5分钟后
    /// 第3次重试：30分钟后
    /// </summary>
    public int[] RetryIntervals { get; set; } = [1, 5, 30];

    /// <summary>
    /// 获取下次重试时间
    /// </summary>
    public DateTime GetNextRetryTime(int currentRetryCount)
    {
        var intervalIndex = Math.Min(currentRetryCount, RetryIntervals.Length - 1);
        var intervalMinutes = RetryIntervals[intervalIndex];
        return DateTime.Now.AddMinutes(intervalMinutes);
    }

    /// <summary>
    /// 不同通知类型的默认有效期（小时）
    /// </summary>
    public static TimeSpan GetDefaultExpireTime(NotificationType notificationType, string? subType)
    {
        // 特殊子类型处理
        if (!string.IsNullOrEmpty(subType))
        {
            return subType.ToLower() switch
            {
                "intercom_request" => TimeSpan.FromMinutes(5),  // 对讲请求，5分钟有效
                _ => TimeSpan.FromHours(2)  // 其他子类型默认2小时
            };
        }

        // 按大类处理
        return notificationType switch
        {
            NotificationType.SystemAnnouncement => TimeSpan.FromHours(24),  // 系统公告24小时
            NotificationType.BusinessNotification => TimeSpan.FromHours(12),  // 审批通知12小时
            NotificationType.SystemNotification => TimeSpan.FromHours(6),  // 任务提醒6小时
            _ => TimeSpan.FromHours(2)  // 其他2小时
        };
    }
}
