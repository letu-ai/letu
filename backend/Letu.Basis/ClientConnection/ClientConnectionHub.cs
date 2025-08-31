using System.Collections.Concurrent;
using Volo.Abp.DependencyInjection;

namespace Letu.Basis.ClientConnection;

public class ClientConnectionHub : IClientConnectionHub, ISingletonDependency
{
    private readonly ConcurrentDictionary<string, Guid> connections = new();
    private readonly ConcurrentDictionary<Guid, List<string>> userConnections = new();
    private readonly ConcurrentDictionary<string, Func<string, object?, Task>> connectionHandlers = new();
    private readonly ConcurrentDictionary<string, List<string>> sessionConnections = new();
    private readonly ILogger<ClientConnectionHub> logger;

    public ClientConnectionHub(ILogger<ClientConnectionHub> logger)
    {
        this.logger = logger;
    }

    public Task AddConnectionAsync(Guid userId, string connectionId, Func<string, object?, Task> handler, string? sessionId = null)
    {
        // 注册连接处理器
        connectionHandlers[connectionId] = handler;
        
        // 建立用户连接映射
        connections[connectionId] = userId;
        
        userConnections.AddOrUpdate(userId, 
            new List<string> { connectionId },
            (key, existing) => 
            {
                existing.Add(connectionId);
                return existing;
            });

        // 建立会话连接映射
        if (!string.IsNullOrEmpty(sessionId))
        {
            sessionConnections.AddOrUpdate(sessionId,
                new List<string> { connectionId },
                (key, existing) =>
                {
                    existing.Add(connectionId);
                    return existing;
                });
        }

        logger.LogInformation($"用户 {userId} 建立 SSE 连接: {connectionId}" + 
            (string.IsNullOrEmpty(sessionId) ? "" : $", 会话: {sessionId}"));
        return Task.CompletedTask;
    }

    public Task RemoveConnectionAsync(string connectionId)
    {
        // 移除连接处理器
        connectionHandlers.TryRemove(connectionId, out _);
        
        // 移除用户连接映射
        if (connections.TryRemove(connectionId, out var userId))
        {
            if (userConnections.TryGetValue(userId, out var connections))
            {
                connections.Remove(connectionId);
                if (connections.Count == 0)
                {
                    userConnections.TryRemove(userId, out _);
                }
            }

            // 清理会话连接映射
            var sessionsToClean = new List<string>();
            foreach (var kvp in sessionConnections)
            {
                if (kvp.Value.Contains(connectionId))
                {
                    kvp.Value.Remove(connectionId);
                    if (kvp.Value.Count == 0)
                    {
                        sessionsToClean.Add(kvp.Key);
                    }
                }
            }
            foreach (var sessionId in sessionsToClean)
            {
                sessionConnections.TryRemove(sessionId, out _);
            }
            
            logger.LogInformation($"用户 {userId} 断开 SSE 连接: {connectionId}");
        }
        return Task.CompletedTask;
    }

    public async Task SendMessageToUserAsync<T>(Guid userId, string type, T? payload)
    {
        if (userConnections.TryGetValue(userId, out var connections))
        {
            var tasks = connections.Select(async connectionId =>
            {
                try
                {
                    await SendToConnection(connectionId, type, payload);
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, $"发送消息到连接 {connectionId} 失败");
                    await RemoveConnectionAsync(connectionId);
                }
            });

            await Task.WhenAll(tasks);
        }
    }

    public async Task SendMessageToAllAsync<T>(string type, T? payload)
    {
        var tasks = connections.Keys.Select(async connectionId =>
        {
            try
            {
                await SendToConnection(connectionId, type, payload);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, $"发送广播消息到连接 {connectionId} 失败");
                await RemoveConnectionAsync(connectionId);
            }
        });

        await Task.WhenAll(tasks);
    }

    private async Task SendToConnection(string connectionId, string eventType, object? data)
    {
        if (connectionHandlers.TryGetValue(connectionId, out var handler))
        {
            try
            {
                await handler(eventType, data);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, $"发送消息到连接 {connectionId} 失败");
                await RemoveConnectionAsync(connectionId);
            }
        }
    }

    public Task RemoveConnectionsBySessionAsync(Guid userId, string sessionId)
    {
        if (sessionConnections.TryRemove(sessionId, out var connectionIds))
        {
            var tasks = connectionIds.Select(connectionId => RemoveConnectionAsync(connectionId));
            logger.LogInformation($"移除用户 {userId} 会话 {sessionId} 的 {connectionIds.Count} 个连接");
            return Task.WhenAll(tasks);
        }
        
        return Task.CompletedTask;
    }
}