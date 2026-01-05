using Letu.AI.Workflows.Templates.Dtos;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.AI.Workflows.Templates;

/// <summary>
/// 工作流模板应用服务接口
/// </summary>
public interface IWorkflowTemplateAppService : IApplicationService
{
    /// <summary>
    /// 获取工作流模板列表
    /// </summary>
    Task<List<WorkflowTemplateOutput>> GetListAsync();

    /// <summary>
    /// 获取工作流模板详情
    /// </summary>
    Task<WorkflowTemplateOutput> GetAsync(Guid id);

    /// <summary>
    /// 创建工作流模板
    /// </summary>
    Task<WorkflowTemplateOutput> CreateAsync(WorkflowTemplateCreateInput input);

    /// <summary>
    /// 更新工作流模板
    /// </summary>
    Task<WorkflowTemplateOutput> UpdateAsync(Guid id, WorkflowTemplateUpdateInput input);

    /// <summary>
    /// 删除工作流模板
    /// </summary>
    Task DeleteAsync(Guid id);

    /// <summary>
    /// 发布工作流模板
    /// </summary>
    Task<WorkflowTemplateOutput> PublishAsync(Guid id);
}

