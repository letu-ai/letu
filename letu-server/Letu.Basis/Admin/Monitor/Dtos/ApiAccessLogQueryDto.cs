namespace Letu.Basis.Admin.Monitor.Dtos
{
    public class ApiAccessLogQueryDto : PageSearch
    {
        public string? UserName { get; set; }
        public string? Path { get; set; }
    }
}