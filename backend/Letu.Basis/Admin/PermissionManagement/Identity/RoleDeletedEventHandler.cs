using Letu.Basis.Admin.Roles;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;
using Volo.Abp.PermissionManagement;
using Volo.Abp.Uow;

namespace Letu.Basis.Admin.PermissionManagement.Identity;

public class RoleDeletedEventHandler :
    IDistributedEventHandler<EntityDeletedEto<RoleEto>>,
    ITransientDependency
{
    protected IPermissionManager PermissionManager { get; }

    public RoleDeletedEventHandler(IPermissionManager permissionManager)
    {
        PermissionManager = permissionManager;
    }

    [UnitOfWork]
    public virtual async Task HandleEventAsync(EntityDeletedEto<RoleEto> eventData)
    {
        await PermissionManager.DeleteAsync(RolePermissionValueProvider.ProviderName, eventData.Entity.Name);
    }
}
