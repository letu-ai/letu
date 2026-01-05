using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.Unicode;

namespace Letu.AI.Json;
public static class AIJsonSerializerOptions
{
    private static readonly JsonSerializerOptions web = new JsonSerializerOptions(JsonSerializerDefaults.Web);
    private static readonly JsonSerializerOptions ai = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        WriteIndented = true,
        // 忽略null 值
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        Encoder = JavaScriptEncoder.Create(UnicodeRanges.BasicLatin, UnicodeRanges.CjkUnifiedIdeographs),
    };

    static AIJsonSerializerOptions()
    {
    }


    /// <summary>
    /// 和浏览器的JS交互的序列化格式。
    /// camelCase命名规则
    /// </summary>
    public static JsonSerializerOptions Web => web;

    /// <summary>
    /// 和AI服务交互的序列化格式
    /// snake_case_lower命名规则
    /// </summary>
    public static JsonSerializerOptions AI => ai;
}
