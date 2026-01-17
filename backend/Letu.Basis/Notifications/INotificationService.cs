using Letu.Basis.Notifications.Dtos;

namespace Letu.Basis.Notifications;

/// <summary>
/// 通知发送服务接口 - 统一的通知发送入口
/// </summary>
/// <remarks>
/// 本服务负责：
/// 1. 保存通知到数据库
/// 2. 创建用户通知记录
/// 3. 触发即时推送（异步，不阻塞调用方）
/// 4. 推送失败会由 NotificationPushRetryWorker 自动重试
/// </remarks>
public interface INotificationService
{
    /// <summary>
    /// 发送通知
    /// </summary>
    /// <param name="input">通知输入参数（支持按范围或直接指定用户）</param>
    /// <returns>通知ID</returns>
    Task<Guid> CreateNotificationAsync(SendNotificationInput input);
}
