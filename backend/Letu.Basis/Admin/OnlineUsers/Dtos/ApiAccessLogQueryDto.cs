namespace Letu.Basis.Admin.OnlineUsers.Dtos
{
    public class ApiAccessLogQueryDto : PageSearch
    {
        public string? UserName { get; set; }
        public string? Path { get; set; }
    }
}