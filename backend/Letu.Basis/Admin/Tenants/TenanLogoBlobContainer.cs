using Volo.Abp.BlobStoring;

namespace Letu.Basis.Admin.Tenants;

     
[BlobContainerName("tenant-logo")]
public class TenantLogoBlobContainer
{
    public static string Name => "tenant-logo";
}

