using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.NotificationManagement.Dtos;
using Letu.Core.Applications;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.EventBus.Distributed;
using Volo.Abp.Uow;
using Volo.Abp.Users;
using Letu.Core.AspNetCore.Mvc;

namespace Letu.Basis.Admin.NotificationManagement;

public class NotificationAppService : BasisAppService, INotificationAppService
{
    private readonly IFreeSqlRepository<Notification> notificationRepository;
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
    private readonly IFreeSqlRepository<Employee> employeeRepository;
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly ICurrentUser currentUser;
    private readonly IDistributedEventBus distributedEventBus;

    public NotificationAppService(
        IFreeSqlRepository<Notification> notificationRepository,
        IFreeSqlRepository<UserNotification> userNotificationRepository,
        IFreeSqlRepository<Employee> employeeRepository,
        IFreeSqlRepository<User> userRepository,
        ICurrentUser currentUser,
        IDistributedEventBus distributedEventBus)
    {
        this.notificationRepository = notificationRepository;
        this.userNotificationRepository = userNotificationRepository;
        this.employeeRepository = employeeRepository;
        this.userRepository = userRepository;
        this.currentUser = currentUser;
        this.distributedEventBus = distributedEventBus;
    }

    public async Task<Guid> CreateNotificationAsync(NotificationDto dto)
    {
        var notification = new Notification
        {
            Title = dto.Title,
            Content = dto.Content,
            NotificationType = dto.NotificationType,
            SendScopeType = dto.SendScopeType,
            SendScopeValue = dto.SendScopeValue,
            Priority = dto.Priority,
            ExpireTime = dto.ExpireTime,
            SenderId = CurrentUser.GetId(),
            Status = dto.IsPublish ? NotificationStatus.Published : NotificationStatus.Draft
        };

        if (dto.IsPublish)
        {
            notification.PublishTime = DateTime.Now;
        }

        var result = await notificationRepository.InsertAsync(notification);

        if (dto.IsPublish)
        {
            await CreateUserNotificationsAsync(result.Id, dto.SendScopeType, dto.SendScopeValue);

            // 发布通知发布事件
            await distributedEventBus.PublishAsync(new NotificationPublishedEto
            {
                NotificationId = result.Id,
                SendScopeType = dto.SendScopeType,
                SendScopeValue = dto.SendScopeValue,
                TenantId = CurrentTenant.Id
            });
        }

        return result.Id;
    }

    public async Task<PagedResult<NotificationResultDto>> GetNotificationListAsync(NotificationQueryDto dto)
    {
        var query = notificationRepository.Select
            .From<User>()
            .LeftJoin((n, sender) => n.SenderId == sender.Id)
            .WhereIf(!string.IsNullOrEmpty(dto.Title), (n, sender) => n.Title!.Contains(dto.Title!))
            .WhereIf(dto.NotificationType.HasValue, (n, sender) => n.NotificationType == dto.NotificationType)
            .WhereIf(dto.Status.HasValue, (n, sender) => n.Status == dto.Status)
            .WhereIf(dto.SendScopeType.HasValue, (n, sender) => n.SendScopeType == dto.SendScopeType)
            .WhereIf(dto.Priority.HasValue, (n, sender) => n.Priority == dto.Priority)
            .WhereIf(dto.StartTime.HasValue, (n, sender) => n.CreationTime >= dto.StartTime)
            .WhereIf(dto.EndTime.HasValue, (n, sender) => n.CreationTime <= dto.EndTime)
            .OrderByDescending((n, sender) => n.CreationTime);

        var list = await query
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync((n, sender) => new NotificationResultDto
            {
                Id = n.Id,
                Title = n.Title,
                Content = n.Content,
                NotificationType = n.NotificationType,
                SendScopeType = n.SendScopeType,
                SendScopeValue = n.SendScopeValue,
                Status = n.Status,
                PublishTime = n.PublishTime,
                ExpireTime = n.ExpireTime,
                Priority = n.Priority,
                SenderId = n.SenderId,
                SenderName = sender.NickName ?? sender.UserName,
                CreationTime = n.CreationTime
            });

        foreach (var item in list)
        {
            var stats = await userNotificationRepository.Select
                .Where(un => un.NotificationId == item.Id)
                .GroupBy(un => un.IsRead)
                .ToListAsync(g => new { IsRead = g.Key, Count = g.Count() });

            item.RecipientCount = stats.Sum(s => s.Count);
            item.ReadCount = stats.Where(s => s.IsRead).Sum(s => s.Count);
        }

        return new PagedResult<NotificationResultDto>(dto, total, list);
    }

    public async Task<NotificationResultDto> GetNotificationAsync(Guid id)
    {
        var notification = await notificationRepository.Select
            .From<Employee>()
            .LeftJoin((n, sender) => n.SenderId == sender.Id)
            .Where((n, sender) => n.Id == id)
            .FirstAsync((n, sender) => new NotificationResultDto
            {
                Id = n.Id,
                Title = n.Title,
                Content = n.Content,
                NotificationType = n.NotificationType,
                SendScopeType = n.SendScopeType,
                SendScopeValue = n.SendScopeValue,
                Status = n.Status,
                PublishTime = n.PublishTime,
                ExpireTime = n.ExpireTime,
                Priority = n.Priority,
                SenderId = n.SenderId,
                SenderName = sender.Name,
                CreationTime = n.CreationTime
            });

        if (notification == null)
        {
            throw HttpFriendlyException.NotFound("通知不存在");
        }

        var stats = await userNotificationRepository.Select
            .Where(un => un.NotificationId == id)
            .GroupBy(un => un.IsRead)
            .ToListAsync(g => new { IsRead = g.Key, Count = g.Count() });

        notification.RecipientCount = stats.Sum(s => s.Count);
        notification.ReadCount = stats.Where(s => s.IsRead).Sum(s => s.Count);

        return notification;
    }

    public async Task UpdateNotificationAsync(Guid id, NotificationDto dto)
    {
        var notification = await notificationRepository.Where(x => x.Id == id).FirstAsync();

        if (notification.Status == NotificationStatus.Published)
        {
            throw HttpFriendlyException.BadRequest("已发布的通知不能修改");
        }

        notification.Title = dto.Title;
        notification.Content = dto.Content;
        notification.NotificationType = dto.NotificationType;
        notification.SendScopeType = dto.SendScopeType;
        notification.SendScopeValue = dto.SendScopeValue;
        notification.Priority = dto.Priority;
        notification.ExpireTime = dto.ExpireTime;

        if (dto.IsPublish && notification.Status == NotificationStatus.Draft)
        {
            notification.Status = NotificationStatus.Published;
            notification.PublishTime = DateTime.Now;
            await CreateUserNotificationsAsync(id, dto.SendScopeType, dto.SendScopeValue);

            // 发布通知发布事件
            await distributedEventBus.PublishAsync(new NotificationPublishedEto
            {
                NotificationId = id,
                SendScopeType = dto.SendScopeType,
                SendScopeValue = dto.SendScopeValue,
                TenantId = CurrentTenant.Id
            });
        }

        await notificationRepository.UpdateAsync(notification);
    }

    public async Task PublishNotificationAsync(Guid id)
    {
        var notification = await notificationRepository.Where(x => x.Id == id).FirstAsync();

        if (notification.Status != NotificationStatus.Draft)
        {
            throw HttpFriendlyException.BadRequest("只能发布草稿状态的通知");
        }

        notification.Status = NotificationStatus.Published;
        notification.PublishTime = DateTime.Now;

        await notificationRepository.UpdateAsync(notification);
        await CreateUserNotificationsAsync(id, notification.SendScopeType, notification.SendScopeValue);

        // 发布通知发布事件
        await distributedEventBus.PublishAsync(new NotificationPublishedEto
        {
            NotificationId = id,
            SendScopeType = notification.SendScopeType,
            SendScopeValue = notification.SendScopeValue,
            TenantId = CurrentTenant.Id
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
        await userNotificationRepository.DeleteAsync(un => un.NotificationId == id);
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

    public async Task<PagedResult<NotificationRecipientDto>> GetNotificationRecipientsAsync(Guid notificationId, PagedResultRequest request)
    {
        var query = userNotificationRepository.Select
            .From<Employee>()
            .InnerJoin((un, emp) => un.UserId == emp.Id)
            .Where((un, emp) => un.NotificationId == notificationId)
            .OrderByDescending((un, emp) => un.CreationTime);

        var list = await query
            .Count(out var total)
            .Page(request.Current, request.PageSize)
            .ToListAsync((un, emp) => new NotificationRecipientDto
            {
                Id = un.Id,
                UserId = un.UserId,
                UserName = emp.Name,
                IsRead = un.IsRead,
                ReadTime = un.ReadTime,
                CreationTime = un.CreationTime
            });

        return new PagedResult<NotificationRecipientDto>(request, total, list);
    }

    private async Task CreateUserNotificationsAsync(Guid notificationId, SendScopeType sendScopeType, string? sendScopeValue)
    {
        var targetUserIds = await GetTargetUserIdsAsync(sendScopeType, sendScopeValue);

        var userNotifications = targetUserIds.Select(userId => new UserNotification
        {
            NotificationId = notificationId,
            UserId = userId,
            IsRead = false
        }).ToList();

        if (userNotifications.Any())
        {
            await userNotificationRepository.InsertAsync(userNotifications);
        }
    }

    private async Task<List<Guid>> GetTargetUserIdsAsync(SendScopeType sendScopeType, string? sendScopeValue)
    {
        var query = userRepository.Select.Where(u => u.IsEnabled);

        switch (sendScopeType)
        {
            case SendScopeType.SpecificUsers:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var userIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => userIds.Contains(u.Id));
                }
                break;
            case SendScopeType.ByRole:
                break;
            case SendScopeType.ByDepartment:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var deptIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => u.DepartmentId.HasValue && deptIds.Contains(u.DepartmentId.Value));
                }
                break;
            case SendScopeType.ByPosition:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var positionIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => u.PositionId.HasValue && positionIds.Contains(u.PositionId.Value));
                }
                break;
            case SendScopeType.AllUsers:
                break;
        }

        return await query.ToListAsync(u => u.Id);
    }
}