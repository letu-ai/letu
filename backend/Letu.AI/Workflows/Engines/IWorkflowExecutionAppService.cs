using Letu.AI.Workflows.Templates.Dtos;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.AI.Workflows.Engines;

/// <summary>
/// 工作流执行应用服务接口
/// </summary>
public interface IWorkflowExecutionAppService : IApplicationService
{
    /// <summary>
    /// 获取执行列表
    /// </summary>
    Task<List<WorkflowExecutionDto>> GetListAsync();

    /// <summary>
    /// 获取执行详情
    /// </summary>
    Task<WorkflowExecutionDto> GetAsync(string executionId);

    /// <summary>
    /// 开始执行工作流
    /// </summary>
    Task<WorkflowExecutionDto> StartExecutionAsync(StartExecutionInput input);

    /// <summary>
    /// 继续执行工作流
    /// </summary>
    Task<WorkflowExecutionDto> ContinueExecutionAsync(string executionId, ContinueExecutionInput input);

    /// <summary>
    /// 获取执行消息列表
    /// </summary>
    Task<List<ExecutionMessageDto>> GetMessagesAsync(string executionId);
}

