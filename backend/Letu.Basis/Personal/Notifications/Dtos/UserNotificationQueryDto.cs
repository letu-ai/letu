using Letu.Applications;

namespace Letu.Basis.Personal.Notifications.Dtos
{
    public class UserNotificationQueryDto : PagedResultRequest
    {
        public string? Title { get; set; }

        public bool? IsReaded { get; set; }
    }
}