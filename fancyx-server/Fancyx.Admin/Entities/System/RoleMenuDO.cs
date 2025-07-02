using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;

namespace Fancyx.Admin.Entities.System
{
    /// <summary>
    /// 角色菜单表
    /// </summary>
    [Table(Name = "sys_role_menu")]
    public class RoleMenuDO : Entity, ITenant
    {
        /// <summary>
        /// 菜单ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid MenuId { get; set; }

        /// <summary>
        /// 角色ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid RoleId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}