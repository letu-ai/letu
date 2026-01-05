using Microsoft.Extensions.Logging;

namespace Letu.AI.Workflows.Activities;

/// <summary>
/// 文件选择活动
/// 注意：实际的等待逻辑在工作流编排中使用 WaitForExternalEvent 实现
/// 此 Activity 主要用于处理文件选择后的逻辑
/// </summary>
public class FileSelectActivity
{
    private readonly ILogger<FileSelectActivity> logger;

    public FileSelectActivity(ILogger<FileSelectActivity> logger)
    {
        this.logger = logger;
    }

}

