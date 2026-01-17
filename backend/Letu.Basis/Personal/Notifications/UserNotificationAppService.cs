using Letu.Basis.Admin.NotificationManagement;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Users;
using Letu.Basis.Personal.Notifications.Dtos;
using Letu.Basis.Notifications;

namespace Letu.Basis.Personal.Notifications;

public class UserNotificationAppService : BasisAppService, IUserNotificationAppService
{
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;

    public UserNotificationAppService(
        IFreeSqlRepository<UserNotification> userNotificationRepository)
    {
        this.userNotificationRepository = userNotificationRepository;
    }


    public async Task<PagedResult<UserNotificationDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto)
    {
        var userId = CurrentUser.GetId();
        var items = await userNotificationRepository.Select
            .Include(x => x.Notification)
            .Where(x => x.UserId == userId)
            .Where(x => x.Notification!.NotificationType != NotificationType.SystemNotification)  // 不显示 SystemNotification 的通知
            .WhereIf(!string.IsNullOrEmpty(dto.Title), x => x.Notification!.Title.Contains(dto.Title!))
            .WhereIf(dto.IsReaded.HasValue, x => x.IsRead == dto.IsReaded)
            .OrderBy(x => x.IsRead)
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync(x => new UserNotificationDto
            {
                Id = x.Id,
                NotificationId = x.Notification!.Id,
                Title = x.Notification.Title,
                Content = x.Notification.Content,
                NotificationType = x.Notification.NotificationType,
                SubType = x.Notification.SubType,
                Priority = x.Notification.Priority,
                IsReaded = x.IsRead,
                ReadedTime = x.ReadTime,
                CreationTime = x.CreationTime
            });

        return new PagedResult<UserNotificationDto>(dto, total, items);
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
            .Include(x => x.Notification)
            .Where(x => x.UserId == userId && !x.IsDeleted);

        result.Items = await query
            .OrderBy(x => x.IsRead)
            .OrderByDescending(x => x.CreationTime)
            .Take(5)
            .ToListAsync(x => new UserNotificationNavbarItemDto
            {
                Id = x.Id,
                NotificationId = x.Notification!.Id,
                Title = x.Notification.Title,
                Content = x.Notification.Content,
                NotificationType = x.Notification.NotificationType,
                Priority = x.Notification.Priority,
                IsReaded = x.IsRead,
                CreationTime = x.CreationTime
            });

        result.NoReadedCount = (int)await query.Where(x => !x.IsRead).CountAsync();
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
}