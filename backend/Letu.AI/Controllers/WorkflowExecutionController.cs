using Letu.AI.Workflows.Engines;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.AI.Controllers;

/// <summary>
/// 工作流执行 API 控制器
/// </summary>
[ApiController]
[Route("api/ai/executions")]
[Authorize]
public class WorkflowExecutionController : AbpControllerBase
{
    private readonly IWorkflowExecutionAppService executionService;

    public WorkflowExecutionController(IWorkflowExecutionAppService service)
    {
        executionService = service;
    }

    /// <summary>
    /// 获取执行列表
    /// </summary>
    [HttpGet]
    public async Task<List<WorkflowExecutionDto>> GetListAsync()
    {
        return await executionService.GetListAsync();
    }

    /// <summary>
    /// 获取执行详情
    /// </summary>
    [HttpGet("{executionId}")]
    public async Task<WorkflowExecutionDto> GetAsync(string executionId)
    {
        return await executionService.GetAsync(executionId);
    }

    /// <summary>
    /// 开始执行工作流
    /// </summary>
    [HttpPost("workflows/{templateId}/execute")]
    public async Task<WorkflowExecutionDto> StartExecutionAsync(Guid templateId, [FromBody] StartExecutionInput input)
    {
        input.TemplateId = templateId;
        return await executionService.StartExecutionAsync(input);
    }

    /// <summary>
    /// 继续执行工作流
    /// </summary>
    [HttpPost("{executionId}/continue")]
    public async Task<WorkflowExecutionDto> ContinueExecutionAsync(string executionId, [FromBody] ContinueExecutionInput input)
    {
        return await executionService.ContinueExecutionAsync(executionId, input);
    }

    /// <summary>
    /// 获取执行消息列表
    /// </summary>
    [HttpGet("{executionId}/messages")]
    public async Task<List<ExecutionMessageDto>> GetMessagesAsync(string executionId)
    {
        return await executionService.GetMessagesAsync(executionId);
    }

    /// <summary>
    /// SSE 流式输出
    /// </summary>
    [HttpGet("{executionId}/stream")]
    public async Task StreamAsync(string executionId)
    {
        var response = HttpContext.Response;
        response.ContentType = "text/event-stream";
        response.Headers["Cache-Control"] = "no-cache";
        response.Headers["Connection"] = "keep-alive";
        response.Headers["X-Accel-Buffering"] = "no";

        // 注册 SSE 连接

        try
        {
            // 保持连接打开
            while (!HttpContext.RequestAborted.IsCancellationRequested)
            {
                await Task.Delay(1000, HttpContext.RequestAborted);
            }
        }
        catch (OperationCanceledException)
        {
            // 客户端断开连接
        }
        finally
        {
        }
    }
}

