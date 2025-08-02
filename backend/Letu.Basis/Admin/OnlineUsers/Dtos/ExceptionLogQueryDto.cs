using Letu.Applications;

namespace Letu.Basis.Admin.OnlineUsers.Dtos
{
    public class ExceptionLogQueryDto : PagedResultRequest
    {
        public string? UserName { get; set; }

        public string? Path { get; set; }

        public bool? IsHandled { get; set; }
    }
}