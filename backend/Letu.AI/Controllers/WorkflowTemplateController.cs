using Letu.AI.Workflows.Templates;
using Letu.AI.Workflows.Templates.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.AI.Controllers;

/// <summary>
/// 工作流模板 API 控制器
/// </summary>
[ApiController]
[Route("api/ai/workflows")]
[Authorize]
public class WorkflowTemplateController : AbpControllerBase
{
    private readonly IWorkflowTemplateAppService templateService;

    public WorkflowTemplateController(IWorkflowTemplateAppService templateService)
    {
        this.templateService = templateService;
    }

    /// <summary>
    /// 获取工作流模板列表
    /// </summary>
    [HttpGet]
    public async Task<List<WorkflowTemplateOutput>> GetListAsync()
    {
        return await templateService.GetListAsync();
    }

    /// <summary>
    /// 获取工作流模板详情
    /// </summary>
    [HttpGet("{id}")]
    public async Task<WorkflowTemplateOutput> GetAsync(Guid id)
    {
        return await templateService.GetAsync(id);
    }

    /// <summary>
    /// 创建工作流模板
    /// </summary>
    [HttpPost]
    public async Task<WorkflowTemplateOutput> CreateAsync([FromBody] WorkflowTemplateCreateInput input)
    {
        return await templateService.CreateAsync(input);
    }

    /// <summary>
    /// 更新工作流模板
    /// </summary>
    [HttpPut("{id}")]
    public async Task<WorkflowTemplateOutput> UpdateAsync(Guid id, [FromBody] WorkflowTemplateUpdateInput input)
    {
        return await templateService.UpdateAsync(id, input);
    }

    /// <summary>
    /// 删除工作流模板
    /// </summary>
    [HttpDelete("{id}")]
    public async Task DeleteAsync(Guid id)
    {
        await templateService.DeleteAsync(id);
    }

    /// <summary>
    /// 发布工作流模板
    /// </summary>
    [HttpPost("{id}/publish")]
    public async Task<WorkflowTemplateOutput> PublishAsync(Guid id)
    {
        return await templateService.PublishAsync(id);
    }
}

