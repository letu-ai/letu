using Letu.Applications;

namespace Letu.Basis.Admin.Users.Dtos
{
    public class UserQueryDto : PagedResultRequest
    {
        public string? UserName { get; set; }
    }
}