using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Roles.Dtos
{
    public class AssignRoleDto
    {
        /// <summary>
        /// 角色ID
        /// </summary>
        public Guid[]? RoleIds { get; set; }
    }
}