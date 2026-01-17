using Letu.Basis.Admin.NotificationManagement.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.NotificationManagement;

public interface INotificationAppService
{
    /// <summary>
    /// 创建通知
    /// </summary>
    Task<Guid> CreateNotificationAsync(NotificationCreateInput dto);

    /// <summary>
    /// 获取通知列表
    /// </summary>
    Task<PagedResult<NotificationListOutput>> GetNotificationListAsync(NotificationListInput dto);

    /// <summary>
    /// 根据ID获取通知详情
    /// </summary>
    Task<NotificationListOutput> GetNotificationAsync(Guid id);

    /// <summary>
    /// 更新通知
    /// </summary>
    Task UpdateNotificationAsync(Guid id, NotificationCreateInput dto);

    /// <summary>
    /// 发布通知（将草稿状态改为已发布，并创建用户关联记录）
    /// </summary>
    Task PublishNotificationAsync(Guid id);

    /// <summary>
    /// 撤回通知
    /// </summary>
    Task WithdrawNotificationAsync(Guid id);

    /// <summary>
    /// 删除通知
    /// </summary>
    Task DeleteNotificationAsync(Guid[] ids);

    /// <summary>
    /// 清理过期通知
    /// </summary>
    Task CleanExpiredNotificationsAsync();

    /// <summary>
    /// 获取通知接收人列表
    /// </summary>
    Task<PagedResult<NotificationRecipientOutput>> GetNotificationRecipientsAsync(Guid notificationId, PagedResultRequest request);
}