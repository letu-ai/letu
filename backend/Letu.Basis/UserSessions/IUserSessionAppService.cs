using Letu.Basis.UserSessions.Dtos;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话管理服务接口
/// </summary>
public interface IUserSessionAppService
{
    Task<List<UserSessionListOutput>> GetSessionsAsync();
    Task MarkAsInactiveAsync(Guid sessionId);
    Task MarkAsKickedOutAsync(Guid sessionId);
}
