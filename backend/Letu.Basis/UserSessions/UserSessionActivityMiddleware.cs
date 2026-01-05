using Volo.Abp.Users;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话活动时间记录中间件
/// </summary>
public class UserSessionActivityMiddleware
{
    private readonly RequestDelegate next;
    private readonly UserSessionActivityService activityService;

    public UserSessionActivityMiddleware(
        RequestDelegate next,
        UserSessionActivityService activityService)
    {
        this.next = next;
        this.activityService = activityService;
    }

    public async Task InvokeAsync(HttpContext context, ICurrentUser currentUser)
    {
        // 只处理API请求
        if (context.Request.Path.StartsWithSegments("/api") && currentUser.IsAuthenticated)
        {
            var sessionId = currentUser.FindSessionId();
            if (!string.IsNullOrEmpty(sessionId) && Guid.TryParse(sessionId, out var sessionIdGuid))
            {
                // 异步记录活动时间，不阻塞请求
                _ = Task.Run(async () =>
                {
                    try
                    {
                        await activityService.RecordActivityAsync(sessionIdGuid);
                    }
                    catch
                    {
                        // 静默处理错误，不影响主请求
                    }
                });
            }
        }

        await next(context);
    }
}

