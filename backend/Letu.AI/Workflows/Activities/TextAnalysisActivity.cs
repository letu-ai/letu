using Microsoft.Extensions.Logging;

namespace Letu.AI.Workflows.Activities;

/// <summary>
/// 文本分析活动
/// 调用 AI 服务进行文本分析，支持流式输出
/// </summary>
public class TextAnalysisActivity
{
    private readonly ILogger<TextAnalysisActivity> logger;

    public TextAnalysisActivity(
        ILogger<TextAnalysisActivity> logger)
    {
        this.logger = logger;
    }

}

