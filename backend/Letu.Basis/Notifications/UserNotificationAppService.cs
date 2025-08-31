using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.ClientConnection;
using Letu.Basis.Notifications.Dtos;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Users;

namespace Letu.Basis.Notifications;

public class UserNotificationAppService : BasisAppService, IUserNotificationAppService
{
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
    private readonly IFreeSqlRepository<Notification> notificationRepository;
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IClientConnectionHub notificationHub;

    public UserNotificationAppService(
        IFreeSqlRepository<UserNotification> userNotificationRepository,
        IFreeSqlRepository<Notification> notificationRepository,
        IFreeSqlRepository<User> userRepository,
        IClientConnectionHub notificationHub)
    {
        this.userNotificationRepository = userNotificationRepository;
        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
        this.notificationHub = notificationHub;
    }


    public async Task<PagedResult<UserNotificationDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto)
    {
        var userId = CurrentUser.GetId();
        var query = userNotificationRepository.Select
            .From<Notification>()
            .InnerJoin((un, n) => un.NotificationId == n.Id)
            .Where((un, n) => un.UserId == userId)
            .WhereIf(!string.IsNullOrEmpty(dto.Title), (un, n) => n.Title.Contains(dto.Title!))
            .WhereIf(dto.IsReaded.HasValue, (un, n) => un.IsRead == dto.IsReaded);

        var list = await query
            .OrderBy((un, n) => un.IsRead)
            .OrderByDescending((un, n) => un.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync((un, n) => new UserNotificationDto
            {
                Id = un.Id,
                NotificationId = n.Id,
                Title = n.Title,
                Content = n.Content,
                NotificationType = n.NotificationType,
                Priority = n.Priority,
                IsReaded = un.IsRead,
                ReadedTime = un.ReadTime,
                CreationTime = un.CreationTime
            });

        return new PagedResult<UserNotificationDto>(dto, total, list);
    }

    public async Task<UserNotificationDto> GetMyNotificationAsync(Guid id)
    {
        var entity = await userNotificationRepository.Select
            .Include(x => x.Notification)
            .Where(x => x.Id == id)
            .FirstAsync();

        if( entity == null)
            throw new EntityNotFoundException(typeof(UserNotification), id);

        if(entity.Notification == null)
            throw HttpFriendlyException.BadRequest("关联的通知不存在，数据异常");

        return new UserNotificationDto
        {
            Id = entity.Id,
            NotificationId = entity.Notification.Id,
            Title = entity.Notification.Title,
            Content = entity.Notification.Content,
            NotificationType = entity.Notification.NotificationType,
            Priority = entity.Notification.Priority,
            IsReaded = entity.IsRead,
            ReadedTime = entity.ReadTime,
            CreationTime = entity.CreationTime
        };
    }

    public async Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync()
    {
        var result = new UserNotificationNavbarDto();
        var userId = CurrentUser.GetId();
        var query = userNotificationRepository.Select
            .From<Notification>()
            .InnerJoin((un, n) => un.NotificationId == n.Id)
            .Where((un, n) => un.UserId == userId && !un.IsDeleted);

        result.Items = await query
            .OrderBy((un, n) => un.IsRead)
            .OrderByDescending((un, n) => un.CreationTime)
            .Take(5)
            .ToListAsync((un, n) => new UserNotificationNavbarItemDto
            {
                Id = un.Id,
                NotificationId = n.Id,
                Title = n.Title,
                Content = n.Content,
                NotificationType = n.NotificationType,
                Priority = n.Priority,
                IsReaded = un.IsRead,
                CreationTime = un.CreationTime
            });

        result.NoReadedCount = (int)await query.Where((un, n) => !un.IsRead).CountAsync();
        return result;
    }

    public async Task ReadedAsync(Guid[] ids)
    {
        var now = DateTime.Now;
        await userNotificationRepository.UpdateDiy
            .Set(x => x.IsRead, true)
            .Set(x => x.ReadTime, now)
            .Where(x => x.UserId == CurrentUser.Id && ids.Contains(x.Id))
            .ExecuteAffrowsAsync();
    }

    public async Task SendNotificationToUserAsync(Guid userId, string title, string content)
    {
        var notification = new Notification
        {
            Title = title,
            Content = content,
            NotificationType = NotificationType.Other,
            SendScopeType =  SendScopeType.SpecificUsers,
            SendScopeValue = userId.ToString(),
            Priority =  Priority.Normal,
            SenderId = CurrentUser.GetId(),
            Status =  NotificationStatus.Published,
            PublishTime = DateTime.Now
        };

        var savedNotification = await notificationRepository.InsertAsync(notification);

        var userNotification = new UserNotification
        {
            NotificationId = savedNotification.Id,
            UserId = userId,
            IsRead = false
        };

        await userNotificationRepository.InsertAsync(userNotification);

        var notificationDto = new UserNotificationDto
        {
            Id = userNotification.Id,
            NotificationId = savedNotification.Id,
            Title = savedNotification.Title,
            Content = savedNotification.Content,
            NotificationType = savedNotification.NotificationType,
            Priority = savedNotification.Priority,
            IsReaded = false,
            CreationTime = userNotification.CreationTime
        };

        await notificationHub.SendMessageToUserAsync(userId, "notification", notificationDto);
    }

    public async Task SendNotificationToAllAsync(string title, string content)
    {
        var notification = new Notification
        {
            Title = title,
            Content = content,
            NotificationType =  NotificationType.SystemAnnouncement,
            SendScopeType = SendScopeType.AllUsers,
            Priority =  Priority.Normal,
            SenderId = CurrentUser.GetId(),
            Status =  NotificationStatus.Published,
            PublishTime = DateTime.Now
        };

        var savedNotification = await notificationRepository.InsertAsync(notification);
        var userNotifications = await userRepository.Select.ToListAsync(x => new UserNotification
        {
            NotificationId = savedNotification.Id,
            UserId = x.Id,
            IsRead = false
        });

        await userNotificationRepository.InsertAsync(userNotifications);

        var notificationDto = new UserNotificationDto
        {
            NotificationId = savedNotification.Id,
            Title = savedNotification.Title,
            Content = savedNotification.Content,
            NotificationType = savedNotification.NotificationType,
            Priority = savedNotification.Priority,
            IsReaded = false,
            CreationTime = DateTime.Now
        };

        await notificationHub.SendMessageToAllAsync("notification", notificationDto);
    }

    public async Task SendNotificationByRangeAsync(NotificationPublishedEto eventData)
    {
        using (CurrentTenant.Change(eventData.TenantId))
        {
            // 在正确的租户上下文中获取目标用户列表
            var targetUserIds = await GetTargetUserIdsAsync(eventData.SendScopeType, eventData.SendScopeValue);
            
            if (!targetUserIds.Any())
            {
                return;
            }

            var pushData = new { notificationId = eventData.NotificationId };

            if (eventData.SendScopeType == SendScopeType.AllUsers)
            {
                // 全员通知，使用广播
                await notificationHub.SendMessageToAllAsync("notification", pushData);
            }
            else
            {
                // 特定用户通知，循环发送
                var tasks = targetUserIds.Select(userId => 
                    notificationHub.SendMessageToUserAsync(userId, "notification", pushData));
                await Task.WhenAll(tasks);
            }
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
                // 按角色过滤的逻辑，这里先留空，根据实际的角色表结构来实现
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
                // 全体用户，不需要额外过滤
                break;
        }

        return await query.ToListAsync(u => u.Id);
    }
}