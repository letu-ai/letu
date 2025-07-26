using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.IService.System.Dtos
{
    public class AssignMenuDto
    {
        /// <summary>
        /// 角色ID
        /// </summary>
        [Required]
        public Guid RoleId { get; set; }

        /// <summary>
        /// 菜单ID
        /// </summary>
        public Guid[]? MenuIds { get; set; }
    }
}