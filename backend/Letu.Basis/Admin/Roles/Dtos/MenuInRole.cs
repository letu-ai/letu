using Letu.Repository.BaseEntity;
using Letu.Core.Interfaces;
using FreeSql.DataAnnotations;

namespace Letu.Basis.Admin.Roles.Dtos
{
    /// <summary>
    /// 角色菜单表
    /// </summary>
    [Table(Name = "sys_role_menu")]
    public class MenuInRole : Entity, ITenant
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