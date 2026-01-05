using Volo.Abp.BlobStoring;

namespace Letu.AI.FileManager;

     
[BlobContainerName("ai-file")]
public class FileBlobContainer
{
    public static string Name => "ai-file";
}

