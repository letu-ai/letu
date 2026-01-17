using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.UserDevices;
using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.NotificationManagement.Dtos;
using Letu.Basis.Identity;
using Letu.Basis.Notifications;
using Letu.Basis.Notifications.Dtos;
using Letu.Core.Applications;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Uow;
using Volo.Abp.Users;
using Letu.Core.AspNetCore.Mvc;

namespace Letu.Basis.Admin.NotificationManagement;

public class NotificationAppService : BasisAppService, INotificationAppService
{
    private readonly IFreeSqlRepository<Notification> notificationRepository;
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
    private readonly ICurrentUser currentUser;
    private readonly INotificationService notificationService;

    public NotificationAppService(
        IFreeSqlRepository<Notification> notificationRepository,
        IFreeSqlRepository<UserNotification> userNotificationRepository,
        ICurrentUser currentUser,
        INotificationService notificationService)
    {
        this.notificationRepository = notificationRepository;
        this.userNotificationRepository = userNotificationRepository;
        this.currentUser = currentUser;
        this.notificationService = notificationService;
    }

    public async Task<Guid> CreateNotificationAsync(NotificationCreateInput input)
    {
        if (input.IsPublish)
        {
            // 如果立即发布，调用通知服务统一处理
            return await notificationService.CreateNotificationAsync(new SendNotificationInput
            {
                Sender = input.Sender,
                Title = input.Title,
                Content = input.Content,
                NotificationType = input.NotificationType,
                SubType = input.SubType,
                SendScopeType = input.SendScopeType,
                SendScopeValue = input.SendScopeValue,
                ExpireTime = input.ExpireTime,
                Priority = input.Priority,
                TargetPlatform = input.TargetPlatform
            });
        }
        else
        {
            // 保存为草稿
            var notification = new Notification
            {
                Title = input.Title,
                Content = input.Content,
                NotificationType = input.NotificationType,
                SubType = input.SubType,
                SendScopeType = input.SendScopeType,
                SendScopeValue = input.SendScopeValue,
                Priority = input.Priority,
                ExpireTime = input.ExpireTime,
                TargetPlatform = input.TargetPlatform,
                SenderId = CurrentUser.Id,
                Sender = input.Sender ?? currentUser.Name ?? currentUser.UserName ?? "System",
                Status = NotificationStatus.Draft
            };

            var result = await notificationRepository.InsertAsync(notification);
            return result.Id;
        }
    }

    public async Task<PagedResult<NotificationListOutput>> GetNotificationListAsync(NotificationListInput input)
    {
        var items = await notificationRepository.Select
            .WhereIf(!string.IsNullOrEmpty(input.Title), x => x.Title!.Contains(input.Title!))
            .WhereIf(input.NotificationType.HasValue, x => x.NotificationType == input.NotificationType)
            .WhereIf(input.Status.HasValue, x => x.Status == input.Status)
            .WhereIf(input.SendScopeType.HasValue, x => x.SendScopeType == input.SendScopeType)
            .WhereIf(input.Priority.HasValue, x => x.Priority == input.Priority)
            .WhereIf(input.StartTime.HasValue, x => x.CreationTime >= input.StartTime)
            .WhereIf(input.EndTime.HasValue, x => x.CreationTime <= input.EndTime)
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(input.Current, input.PageSize)
            .ToListAsync(x => new NotificationListOutput
            {
                Id = x.Id,
                Title = x.Title,
                Content = x.Content,
                NotificationType = x.NotificationType,
                SendScopeType = x.SendScopeType,
                SendScopeValue = x.SendScopeValue,
                Status = x.Status,
                PublishTime = x.PublishTime,
                ExpireTime = x.ExpireTime,
                Priority = x.Priority,
                SenderId = x.SenderId,
                Sender = x.Sender,
                ReadCount = x.UserNotifications!.Count(x => x.IsRead),
                RecipientCount = x.UserNotifications!.Count(),
                CreationTime = x.CreationTime
            });

        return new PagedResult<NotificationListOutput>(input, total, items);
    }

    public async Task<NotificationListOutput> GetNotificationAsync(Guid id)
    {
        var notification = await notificationRepository.Select
            .Where(x => x.Id == id)
            .FirstAsync(x => new NotificationListOutput
            {
                Id = x.Id,
                Title = x.Title,
                Content = x.Content,
                NotificationType = x.NotificationType,
                SendScopeType = x.SendScopeType,
                SendScopeValue = x.SendScopeValue,
                Status = x.Status,
                PublishTime = x.PublishTime,
                ExpireTime = x.ExpireTime,
                Priority = x.Priority,
                SenderId = x.SenderId,
                Sender = x.Sender,
                ReadCount = x.UserNotifications!.Count(x => x.IsRead),
                RecipientCount = x.UserNotifications!.Count(),
                CreationTime = x.CreationTime
            });

        if (notification == null)
        {
            throw HttpFriendlyException.NotFound("通知不存在");
        }

        return notification;
    }

    public async Task UpdateNotificationAsync(Guid id, NotificationCreateInput dto)
    {
        var notification = await notificationRepository.Where(x => x.Id == id).FirstAsync();

        if (notification.Status == NotificationStatus.Published)
        {
            throw HttpFriendlyException.BadRequest("已发布的通知不能修改");
        }

        if (dto.IsPublish && notification.Status == NotificationStatus.Draft)
        {
            // 从草稿变为发布，先删除草稿，再调用通知服务
            await notificationRepository.DeleteAsync(notification);

            await notificationService.CreateNotificationAsync(new SendNotificationInput
            {
                Sender = dto.Sender,
                SenderId = notification.SenderId,
                Title = dto.Title,
                Content = dto.Content,
                NotificationType = dto.NotificationType,
                SubType = dto.SubType,
                SendScopeType = dto.SendScopeType,
                SendScopeValue = dto.SendScopeValue,
                ExpireTime = dto.ExpireTime,
                Priority = dto.Priority,
                TargetPlatform = dto.TargetPlatform
            });
        }
        else
        {
            // 仍然保持草稿状态，只更新字段
            notification.Title = dto.Title;
            notification.Content = dto.Content;
            notification.NotificationType = dto.NotificationType;
            notification.SubType = dto.SubType;
            notification.SendScopeType = dto.SendScopeType;
            notification.SendScopeValue = dto.SendScopeValue;
            notification.Priority = dto.Priority;
            notification.ExpireTime = dto.ExpireTime;
            notification.TargetPlatform = dto.TargetPlatform;

            await notificationRepository.UpdateAsync(notification);
        }
    }

    public async Task PublishNotificationAsync(Guid id)
    {
        var notification = await notificationRepository.Where(x => x.Id == id).FirstAsync();

        if (notification.Status != NotificationStatus.Draft)
        {
            throw HttpFriendlyException.BadRequest("只能发布草稿状态的通知");
        }

        // 删除草稿记录，调用通知服务重新创建并发布
        await notificationRepository.DeleteAsync(notification);

        await notificationService.CreateNotificationAsync(new SendNotificationInput
        {
            Sender = notification.Sender,
            SenderId = notification.SenderId,
            Title = notification.Title,
            Content = notification.Content,
            NotificationType = notification.NotificationType,
            SubType = notification.SubType,
            SendScopeType = notification.SendScopeType,
            SendScopeValue = notification.SendScopeValue,
            ExpireTime = notification.ExpireTime,
            Priority = notification.Priority,
            TargetPlatform = notification.TargetPlatform
        });
    }

    public async Task WithdrawNotificationAsync(Guid id)
    {
        var notification = await notificationRepository.Where(x => x.Id == id).FirstAsync();

        if (notification.Status != NotificationStatus.Published)
        {
            throw HttpFriendlyException.BadRequest("只能撤回已发布的通知");
        }

        notification.Status = NotificationStatus.Withdrawn;
        await notificationRepository.UpdateAsync(notification);

        // 删除相关的用户通知记录
        await userNotificationRepository.DeleteAsync(x => x.NotificationId == id);
    }

    public async Task DeleteNotificationAsync(Guid[] ids)
    {
        var notifications = await notificationRepository.Select.Where(n => ids.Contains(n.Id)).ToListAsync();

        if (notifications.Any(n => n.Status == NotificationStatus.Published))
        {
            throw HttpFriendlyException.BadRequest("不能删除已发布的通知，请先撤回");
        }

        // 先删除相关的用户通知记录
        await userNotificationRepository.DeleteAsync(un => ids.Contains(un.NotificationId));
        // 再删除通知记录
        await notificationRepository.DeleteAsync(x => ids.Contains(x.Id));
    }

    [UnitOfWork]
    public async Task CleanExpiredNotificationsAsync()
    {
        // TODO：增加过期通知时间设置项，现在硬编码30天
        var beforeDate = DateTime.Now.AddDays(-30);
        var expiredNotifications = await notificationRepository.Select
            .Where(n => n.ExpireTime.HasValue && n.ExpireTime < beforeDate)
            .ToListAsync(n => n.Id);

        if (expiredNotifications.Count != 0)
        {
            await userNotificationRepository.DeleteAsync(un => expiredNotifications.Contains(un.NotificationId));
            await notificationRepository.DeleteAsync(n => expiredNotifications.Contains(n.Id));
        }
    }

    public async Task<PagedResult<NotificationRecipientOutput>> GetNotificationRecipientsAsync(Guid notificationId, PagedResultRequest request)
    {
        var list = await userNotificationRepository.Select
            .Include(x => x.User)
            .Include(x => x.User!.Employee)
            .Include(x => x.User!.Department)
            .Include(x => x.User!.Position)
            .Where(x => x.NotificationId == notificationId)
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(request.Current, request.PageSize)
            .ToListAsync(un => new NotificationRecipientOutput
            {
                Id = un.Id,
                UserId = un.UserId,
                UserName = un.User!.Employee != null ? un.User.Employee.Name : un.User.UserName,
                DepartmentName = un.User.Department != null ? un.User.Department.Name : null,
                PositionName = un.User.Position != null ? un.User.Position.Name : null,
                IsRead = un.IsRead,
                ReadTime = un.ReadTime,
                CreationTime = un.CreationTime,
                PushStatus = un.PushStatus,
                RetryCount = un.RetryCount,
                PushErrorMessage = un.PushErrorMessage
            });

        return new PagedResult<NotificationRecipientOutput>(request, total, list);
    }

}