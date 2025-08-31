using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.NotificationManagement;

public class NotificationPublishedEto : IMultiTenant
{
    public Guid NotificationId { get; set; }
    
    public SendScopeType SendScopeType { get; set; }
    
    public string? SendScopeValue { get; set; }
    
    public Guid? TenantId { get; set; }
}