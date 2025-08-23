using Letu.Core.Applications;

namespace Letu.Basis.Admin.Roles.Dtos
{
    public class RoleListInput : PagedResultRequest
    {
        /// <summary>
        /// 角色名
        /// </summary>
        public string? Name { get; set; }
    }
}