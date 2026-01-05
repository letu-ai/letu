namespace Letu.AI.ChatCompletions;

/// <summary>
/// 图片附件内容。
/// 是客户端提交给服务的内容，将会转换成ImageUrlContent后才能发给大模型处理。
/// </summary>
/// <param name="id"></param>
public class ImageAttachmentContent(Guid id) : ContentBase(ContentTypes.ImageAttachment)
{
    public ImageAttachmentContent()
    : this(Guid.Empty)
    {

    }

    public Guid AttachmentId { get; set; } = id;
}
