using Letu.Applications;

namespace Letu.Basis.Admin.Users.Dtos
{
    public class UserListInput : PagedResultRequest
    {
        public string? UserName { get; set; }
    }
}