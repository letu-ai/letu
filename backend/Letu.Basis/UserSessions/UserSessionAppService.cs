using Letu.Basis.UserSessions.Dtos;
using Letu.Repository;
using Volo.Abp.Users;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话管理服务
/// </summary>
public class UserSessionAppService : BasisAppService, IUserSessionAppService
{
    private readonly IFreeSqlRepository<UserSession> sessionRepository;

    public UserSessionAppService(IFreeSqlRepository<UserSession> sessionRepository)
    {
        this.sessionRepository = sessionRepository;
    }

    /// <summary>
    /// 获取自己的活动会话
    /// </summary>
    public async Task<List<UserSessionListOutput>> GetSessionsAsync()
    {
        var userId = CurrentUser.GetId();
        return await sessionRepository.Select
            .Where(x => x.UserId == userId)
            .Where(x => x.Status == SessionStatus.Active)
            .OrderByDescending(x => x.LastActiveTime)
            .ToListAsync<UserSessionListOutput>();
    }

    /// <summary>
    /// 标记会话为Inactive
    /// </summary>
    public async Task MarkAsInactiveAsync(Guid sessionId)
    {
        var userId = CurrentUser.GetId();
        var session = await sessionRepository.Select
            .Where(x => x.UserId == userId && x.Id == sessionId)
            .ToOneAsync();

        if (session != null)
        {
            session.Status = SessionStatus.Inactive;
            await sessionRepository.UpdateAsync(session);
        }
    }

    /// <summary>
    /// 标记会话为KickedOut
    /// </summary>
    public async Task MarkAsKickedOutAsync(Guid sessionId)
    {
        var userId = CurrentUser.GetId();
        var session = await sessionRepository.Select
            .Where(x => x.UserId == userId && x.Id == sessionId)
            .ToOneAsync();

        if (session != null)
        {
            session.Status = SessionStatus.KickedOut;
            await sessionRepository.UpdateAsync(session);
        }
    }
}
