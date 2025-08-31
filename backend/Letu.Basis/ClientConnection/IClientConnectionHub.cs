namespace Letu.Basis.ClientConnection;

public interface IClientConnectionHub
{
    Task AddConnectionAsync(Guid userId, string connectionId, Func<string, object?, Task> handler, string? sessionId = null);
    Task RemoveConnectionAsync(string connectionId);
    Task RemoveConnectionsBySessionAsync(Guid userId, string sessionId);
    Task SendMessageToUserAsync<T>(Guid userId, string type, T? payload);
    Task SendMessageToAllAsync<T>(string type, T? payload);
}
