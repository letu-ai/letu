using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Menus
{
    /// <summary>
    /// 角色菜单表
    /// </summary>
    [Table(Name = "sys_menu_feature")]
    public class MenuItemFeature : Entity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 菜单ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid MenuItemId { get; set; }

        /// <summary>
        /// 角色ID
        /// </summary>
        [Column(IsNullable = false)]
        public required string Feature { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}