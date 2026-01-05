namespace Letu.Basis.Identity;

/// <summary>
/// 身份认证缓存帮助类
/// </summary>
public static class IdentityCacheKeys
{
    /// <summary>
    /// 用户会话ID
    /// </summary>
    /// <param name="sessionId"></param>
    /// <returns></returns>
    public static string CalcUserSessionIdKey(Guid sessionId) => CalcUserSessionIdKey(sessionId.ToString("N"));
    public static string CalcUserSessionIdKey(string sessionId) => $"user-session:{sessionId}";
}