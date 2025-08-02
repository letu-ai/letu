using Letu.Applications;

namespace Letu.Basis.Admin.OnlineUsers.Dtos
{
    public class OnlineUserSearchDto : PagedResultRequest
    {
        public string? UserName { get; set; }
    }
}