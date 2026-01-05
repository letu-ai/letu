using Letu.AI.Workflows.Templates.Dtos;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Entities;
using Letu.Basis.Admin.Users;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Users;

namespace Letu.AI.Workflows.Templates;

/// <summary>
/// 工作流模板应用服务
/// </summary>
public class WorkflowTemplateAppService : AIAppService, IWorkflowTemplateAppService
{
    private readonly IFreeSqlRepository<WorkflowTemplate> templateRepository;

    public WorkflowTemplateAppService(
        IFreeSqlRepository<WorkflowTemplate> templateRepository)
    {
        this.templateRepository = templateRepository;
    }

    public async Task<List<WorkflowTemplateOutput>> GetListAsync()
    {
        var templates = await templateRepository.Select
            .Where(x => x.UserId == CurrentUser.GetId())
            .OrderByDescending(x => x.IsPinned)
            .OrderBy(x => x.Name)
            .ToListAsync();

        return ObjectMapper.Map<List<WorkflowTemplate>, List<WorkflowTemplateOutput>>(templates);
    }

    public async Task<WorkflowTemplateOutput> GetAsync(Guid id)
    {
        var template = await templateRepository.Select
            .Where(x => x.Id == id && x.UserId == CurrentUser.GetId())
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        return ObjectMapper.Map<WorkflowTemplate, WorkflowTemplateOutput>(template);
    }

    public async Task<WorkflowTemplateOutput> CreateAsync(WorkflowTemplateCreateInput input)
    {
        // 验证流程数据格式
        ValidateFlowData(input.FlowData);

    

        var template = new WorkflowTemplate
        {
            UserId = CurrentUser.GetId(),
            Name = input.Name,
            Description = input.Description,
            FlowData = input.FlowData
        };

        await templateRepository.InsertAsync(template);

        return ObjectMapper.Map<WorkflowTemplate, WorkflowTemplateOutput>(template);
    }

    public async Task<WorkflowTemplateOutput> UpdateAsync(Guid id, WorkflowTemplateUpdateInput input)
    {
        var template = await templateRepository.Select
            .Where(x => x.Id == id && x.UserId == CurrentUser.GetId())
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        if (!string.IsNullOrEmpty(input.Name))
        {
            template.Name = input.Name;
        }

        if (input.Description != null)
        {
            template.Description = input.Description;
        }

        if (!string.IsNullOrEmpty(input.FlowData))
        {
            ValidateFlowData(input.FlowData);
            template.FlowData = input.FlowData;
            // 修改设计后标记为未发布
            template.IsPublished = false;
        }

        await templateRepository.UpdateAsync(template);

        return ObjectMapper.Map<WorkflowTemplate, WorkflowTemplateOutput>(template);
    }

    public async Task DeleteAsync(Guid id)
    {
        var template = await templateRepository.Select
            .Where(x => x.Id == id && x.UserId == CurrentUser.GetId())
            .FirstAsync()
            ?? throw new EntityNotFoundException();


        await templateRepository.DeleteAsync(template);
    }

    public async Task<WorkflowTemplateOutput> PublishAsync(Guid id)
    {
        var template = await templateRepository.Select
            .Where(x => x.Id == id && x.UserId == CurrentUser.GetId())
            .FirstAsync()
            ?? throw new EntityNotFoundException();

        if (string.IsNullOrEmpty(template.FlowData))
        {
            throw HttpFriendlyException.BadRequest("工作流没有设计数据，无法发布");
        }

        // 验证流程数据
        ValidateFlowData(template.FlowData);

        // 更新版本号和发布状态
        template.Version++;
        template.IsPublished = true;
        template.LastPublishedTime = DateTime.UtcNow;

        await templateRepository.UpdateAsync(template);

        Logger.LogInformation("工作流模板 {TemplateId} 已发布，版本号: {Version}", template.Id, template.Version);

        return ObjectMapper.Map<WorkflowTemplate, WorkflowTemplateOutput>(template);
    }

    /// <summary>
    /// 验证流程数据格式
    /// </summary>
    private void ValidateFlowData(string flowData)
    {
        if (string.IsNullOrWhiteSpace(flowData))
        {
            throw HttpFriendlyException.BadRequest("流程数据不能为空");
        }

        try
        {
            var json = JsonDocument.Parse(flowData);
            
            // 验证必须包含 nodes 和 edges
            if (!json.RootElement.TryGetProperty("nodes", out _))
            {
                throw HttpFriendlyException.BadRequest("流程数据必须包含 nodes");
            }

            if (!json.RootElement.TryGetProperty("edges", out _))
            {
                throw HttpFriendlyException.BadRequest("流程数据必须包含 edges");
            }
        }
        catch (JsonException ex)
        {
            throw HttpFriendlyException.BadRequest($"流程数据格式错误: {ex.Message}");
        }
    }
}

