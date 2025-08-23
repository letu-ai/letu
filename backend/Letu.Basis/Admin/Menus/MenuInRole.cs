using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Menus
{
    /// <summary>
    /// 角色菜单表
    /// </summary>
    [Table(Name = "sys_role_menu")]
    public class MenuInRole : Entity<Guid>, IMultiTenant
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
        public Guid? TenantId { get; set; }
    }
}