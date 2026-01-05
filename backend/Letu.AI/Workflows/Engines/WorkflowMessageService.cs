using Letu.AI.WorkflowTemplates.WorkflowEngines.Entities;
using Letu.Repository;
using Microsoft.Extensions.Logging;
using Volo.Abp.Domain.Repositories;

namespace Letu.AI.Workflows.Engines;

/// <summary>
/// 工作流消息服务
/// 负责记录工作流执行过程中的对话消息
/// </summary>
public class WorkflowMessageService
{
    private readonly IFreeSqlRepository<ExecutionMessage> _messageRepository;
    private readonly ILogger<WorkflowMessageService> _logger;

    public WorkflowMessageService(
        IFreeSqlRepository<ExecutionMessage> messageRepository,
        ILogger<WorkflowMessageService> logger)
    {
        _messageRepository = messageRepository;
        _logger = logger;
    }

    /// <summary>
    /// 添加消息
    /// </summary>
    public async Task AddMessageAsync(string instanceId, string? nodeId, string role, string content)
    {
        var message = new ExecutionMessage
        {
            InstanceId = instanceId,
            NodeId = nodeId,
            Role = role,
            Content = content
        };

        await _messageRepository.InsertAsync(message);
        _logger.LogDebug("添加消息: InstanceId={InstanceId}, NodeId={NodeId}, Role={Role}", instanceId, nodeId, role);
    }

    /// <summary>
    /// 更新或添加消息（用于流式消息的增量更新）
    /// </summary>
    public async Task UpdateOrAddMessageAsync(string instanceId, string? nodeId, string role, string content)
    {
        // 查找是否已有该节点的最新消息（用于流式更新）
        var existingMessage = await _messageRepository.Select
            .Where(x => x.InstanceId == instanceId && x.NodeId == nodeId && x.Role == role)
            .OrderByDescending(x => x.CreationTime)
            .FirstAsync();

        if (existingMessage != null)
        {
            // 更新现有消息
            existingMessage.Content = content;
            await _messageRepository.UpdateAsync(existingMessage);
            _logger.LogDebug("更新消息: InstanceId={InstanceId}, NodeId={NodeId}, Role={Role}", instanceId, nodeId, role);
        }
        else
        {
            // 创建新消息
            await AddMessageAsync(instanceId, nodeId, role, content);
        }
    }

    /// <summary>
    /// 获取消息列表
    /// </summary>
    public async Task<List<ExecutionMessage>> GetMessagesAsync(string instanceId)
    {
        return await _messageRepository.Select
            .Where(x => x.InstanceId == instanceId)
            .OrderBy(x => x.CreationTime)
            .ToListAsync();
    }
}

