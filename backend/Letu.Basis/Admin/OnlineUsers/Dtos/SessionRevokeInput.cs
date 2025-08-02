namespace Letu.Basis.Admin.OnlineUsers.Dtos
{
    public class SessionRevokeInput
    {
        public required string UserId { get; set; }

        public required string SessionId { get; set; }
    }
}
