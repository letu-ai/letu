namespace Letu.AI.ChatCompletions;

public class ImageUrlContent(string url) : ContentBase("image_url")
{
    public ImageUrlContent()
    : this("")
    {

    }

    public ImageUrl ImageUrl { get; set; } = new(url);
}
