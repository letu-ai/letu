using Microsoft.Extensions.Logging;

namespace Letu.AI.Workflows.Activities;

/// <summary>
/// 用户输入活动
/// 注意：实际的等待逻辑在工作流编排中使用 WaitForExternalEvent 实现
/// 此 Activity 主要用于处理用户输入后的逻辑
/// </summary>
public class UserInputActivity
{
    private readonly ILogger<UserInputActivity> logger;

    public UserInputActivity(ILogger<UserInputActivity> logger)
    {
        this.logger = logger;
    }

}

