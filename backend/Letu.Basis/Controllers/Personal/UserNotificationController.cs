using Letu.Basis.ClientConnection;
using Letu.Basis.Notifications;
using Letu.Basis.Notifications.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Text.Json;
using Volo.Abp.Users;

namespace Letu.Basis.Controllers.Personal;

[ApiController]
[Authorize]
[Route("/api/my/notification")]
public class UserNotificationController : ControllerBase
{
    private readonly IUserNotificationAppService userNotificationService;
    private readonly ICurrentUser currentUser;
    private readonly IClientConnectionHub notificationHub;
    private readonly IHostApplicationLifetime applicationLifetime;

    public UserNotificationController(
        IUserNotificationAppService userNotificationService,
        ICurrentUser currentUser,
        IClientConnectionHub notificationHub,
        IHostApplicationLifetime applicationLifetime)
    {
        this.userNotificationService = userNotificationService;
        this.currentUser = currentUser;
        this.notificationHub = notificationHub;
        this.applicationLifetime = applicationLifetime;
    }

    [HttpGet("stream")]
    public async Task StreamNotifications(CancellationToken cancellationToken)
    {
        var userId = currentUser.GetId();
        var sessionId = currentUser.GetSessionId();
        var connectionId = Guid.NewGuid().ToString();
        
        // 创建组合的 CancellationToken，监听请求中止和应用程序关闭
        using var combinedTokenSource = CancellationTokenSource.CreateLinkedTokenSource(
            cancellationToken, 
            applicationLifetime.ApplicationStopping);
        var combinedToken = combinedTokenSource.Token;
        
        Response.Headers.Append("Content-Type", "text/event-stream");
        Response.Headers.Append("Cache-Control", "no-cache");
        Response.Headers.Append("Connection", "keep-alive");
        Response.Headers.Append("Access-Control-Allow-Origin", "*");

        // 注册连接到ClientConnectionHub并设置消息处理器
        await notificationHub.AddConnectionAsync(userId, connectionId, WriteSSEMessage, sessionId);

        try
        {
            // 发送连接成功消息
            await WriteSSEMessage("connected", new { message = "连接成功" });

            // 保持连接活跃，定期发送心跳
            while (!combinedToken.IsCancellationRequested)
            {
                await Task.Delay(30_000, combinedToken); // 30秒心跳
                await WriteSSEMessage("heartbeat", new { timestamp = DateTime.Now });
            }
        }
        catch (OperationCanceledException)
        {
            // 正常取消，不需要处理
        }
        catch (Exception ex)
        {
            // 记录错误但不抛出，避免影响其他连接
            Console.WriteLine($"SSE连接错误: {ex.Message}");
        }
        finally
        {
            // 清理连接
            await notificationHub.RemoveConnectionAsync(connectionId);
        }
    }

    [HttpGet]
    public async Task<PagedResult<UserNotificationDto>> GetMyNotificationListAsync([FromQuery] UserNotificationQueryDto dto)
    {
        return await userNotificationService.GetMyNotificationListAsync(dto);
    }

    [HttpGet("{id}")]
    public async Task<UserNotificationDto> GetMyNotificationAsync(Guid id)
    {
        return await userNotificationService.GetMyNotificationAsync(id);
    }

    [HttpPut("mark-as-read")]
    public async Task ReadedAsync([FromBody] Guid[] ids)
    {
        await userNotificationService.ReadedAsync(ids);
    }

    [HttpGet("navbar-info")]
    public async Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync()
    {
        return await userNotificationService.GetMyNotificationNavbarInfoAsync();
    }

    private async Task WriteSSEMessage(string eventType, object? data)
    {
        var json = data == null ? "" : JsonSerializer.Serialize(data);
        var message = $"event: {eventType}\ndata: {json}\n\n";
        var bytes = Encoding.UTF8.GetBytes(message);
        
        await Response.Body.WriteAsync(bytes);
        await Response.Body.FlushAsync();
    }
}