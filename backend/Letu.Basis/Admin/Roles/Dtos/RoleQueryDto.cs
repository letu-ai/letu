using Letu.Applications;

namespace Letu.Basis.Admin.Roles.Dtos
{
    public class RoleQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 角色名
        /// </summary>
        public string? RoleName { get; set; }
    }
}