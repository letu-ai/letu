namespace Letu.Basis.Oss;
public static class MimeMapper
{
    private static Dictionary<string, string> imageMimeTypes = new()
        {
            // 图片
            { ".jpg", "image/jpeg" },
            { ".jpeg", "image/jpeg" },
            { ".png", "image/png" },
            { ".gif", "image/gif" },
            { ".bmp", "image/bmp" },
            { ".tiff", "image/tiff" },
            { ".ico", "image/x-icon" },
            { ".svg", "image/svg+xml" },
            { ".webp", "image/webp" },

            // 文档
            { ".doc", "application/msword" },
            { ".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" },
            { ".xls", "application/vnd.ms-excel" },
            { ".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" },
            { ".ppt", "application/vnd.ms-powerpoint" },
            { ".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation" },
            { ".pdf", "application/pdf" },
            { ".txt", "text/plain" },
            { ".csv", "text/csv" },
            { ".md", "text/markdown" }, 

            // 视频
            { ".mp4", "video/mp4" },
            { ".avi", "video/x-msvideo" },
            { ".mov", "video/quicktime" },

            // 音频
            { ".mp3", "audio/mpeg" },
            { ".wav", "audio/wav" },
            { ".ogg", "audio/ogg" },

            // 压缩包
            { ".zip", "application/zip" },
            { ".rar", "application/x-rar-compressed" },
            { ".tar", "application/x-tar" },
            { ".gz", "application/gzip" },
            { ".bz2", "application/x-bzip2" },
            { ".7z", "application/x-7z-compressed" },

            // 其他
            { ".xml", "application/xml" },
            { ".json", "application/json" },
            { ".html", "text/html" },
            { ".css", "text/css" },
            { ".js", "text/javascript" },
        };

    public static string GetContentType(string filename, string defaultType = "application/octet-stream")
    {
        var ext = Path.GetExtension(filename);
        if (imageMimeTypes.TryGetValue(ext, out var mimeType))
            return mimeType;
        else
            return defaultType;
    }

}
