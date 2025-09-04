using Volo.Abp.BlobStoring;

namespace Letu.Basis.Oss;

     
[BlobContainerName("user-avatar")]
public class AvatarBlobContainer
{
    public static string Name => "user-avatar";
}

