namespace Letu.Basis.Personal.Notifications.Dtos
{
    public class UserNotificationQueryDto : PageSearch
    {
        public string? Title { get; set; }

        public bool? IsReaded { get; set; }
    }
}