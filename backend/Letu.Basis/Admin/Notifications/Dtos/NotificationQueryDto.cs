using Letu.Applications;

namespace Letu.Basis.Admin.Notifications.Dtos
{
    public class NotificationQueryDto : PagedResultRequest
    {
        public string? Title { get; set; }

        public bool? IsReaded { get; set; }
    }
}