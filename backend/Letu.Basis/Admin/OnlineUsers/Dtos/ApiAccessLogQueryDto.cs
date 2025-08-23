using Letu.Core.Applications;

namespace Letu.Basis.Admin.OnlineUsers.Dtos
{
    public class ApiAccessLogQueryDto : PagedResultRequest
    {
        public string? UserName { get; set; }
        public string? Path { get; set; }
    }
}