using Letu.Core.Applications;

namespace Letu.Basis.Admin.OnlineUsers.Dtos;

public class OnlineUserListInput : PagedResultRequest
{
    public string? UserName { get; set; }
}