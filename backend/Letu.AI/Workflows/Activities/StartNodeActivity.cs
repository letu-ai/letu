using Letu.AI.FileManager;
using Microsoft.Extensions.Logging;

namespace Letu.AI.Workflows.Activities;

/// <summary>
/// 开始节点活动
/// 负责读取上传的文件（PDF/Excel/Word）并提取内容
/// </summary>
public class StartNodeActivity
{
    private readonly FileManagerAppService fileManager;
    private readonly ILogger<StartNodeActivity> logger;

    public StartNodeActivity(FileManagerAppService fileManager, ILogger<StartNodeActivity> logger)
    {
        this.fileManager = fileManager;
        this.logger = logger;
    }

}

