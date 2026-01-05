namespace Letu.AI.ChatCompletions;

public class ObjectClientMessage : ClientMessage
{
    public ObjectClientMessage(string role)
        : base(role)
    {
        Content = [];
    }
    /// <summary>
    /// 对象型对话内容。
    /// 比如包括图片、文件附件的对话内容。
    /// </summary>
    public ContentBase[] Content { get; set; }
}