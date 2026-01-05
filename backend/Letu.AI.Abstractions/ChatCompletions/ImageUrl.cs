namespace Letu.AI.ChatCompletions;

public class ImageUrl(string url, string detail = "auto")
{
    public ImageUrl()
        : this("")
    {

    }

    public string Url { get; set; } = url;

    /// <summary>
    /// low, high, or auto
    /// 参见：https://platform.openai.com/docs/guides/vision
    /// </summary>
    public string Detail { get; set; } = detail;
}