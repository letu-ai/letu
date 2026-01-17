using AutoMapper;
using Letu.Basis.Admin.NotificationManagement.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.NotificationManagement;

public class NotificationAutoMapperProfile : Profile
{
    public NotificationAutoMapperProfile()
    {
        CreateMap<Notification, NotificationListOutput>()
            .Ignore(d => d.Sender)
            .Ignore(d => d.RecipientCount)
            .Ignore(d => d.ReadCount);
            
        CreateMap<NotificationCreateInput, Notification>(MemberList.Source)
            .ForSourceMember(s => s.IsPublish, opt => opt.DoNotValidate())
            .Ignore(d => d.Id)
            .Ignore(d => d.Status)
            .Ignore(d => d.PublishTime)
            .Ignore(d => d.SenderId)
            .Ignore(d => d.CreationTime)
            .Ignore(d => d.CreatorId)
            .Ignore(d => d.LastModificationTime)
            .Ignore(d => d.LastModifierId)
            .Ignore(d => d.TenantId);

        CreateMap<UserNotification, NotificationRecipientOutput>()
            .Ignore(d => d.UserName)
            .Ignore(d => d.DepartmentName)
            .Ignore(d => d.PositionName);
    }
}