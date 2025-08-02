using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Shared.Enums;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Menus
{
    /// <summary>
    /// 菜单表
    /// </summary>
    [Table(Name = "sys_menu")]
    public class MenuItem : AuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 显示标题/名称
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(32)]
        [Column(IsNullable = false, StringLength = 32)]
        public string? Title { get; set; }

        /// <summary>
        /// 图标
        /// </summary>
        [StringLength(64)]
        [Column(StringLength = 64)]
        public string? Icon { get; set; }

        /// <summary>
        /// 路由/地址
        /// </summary>
        [StringLength(256)]
        [Column(StringLength = 256)]
        public string? Path { get; set; }

        /// <summary>
        /// 组件地址
        /// </summary>
        [StringLength(256)]
        [Column(StringLength = 256)]
        public string? Component { get; set; }

        /// <summary>
        /// 功能类型
        /// </summary>
        public MenuType MenuType { get; set; }

        /// <summary>
        /// 授权码
        /// </summary>
        [NotNull]
        [StringLength(128)]
        [Column(StringLength = 128)]
        public string? Permission { get; set; }

        /// <summary>
        /// 父级ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 是否隐藏
        /// </summary>
        public bool Display { get; set; }

        /// <summary>
        /// 角色菜单
        /// </summary>
        public virtual ICollection<MenuInRole>? RoleMenus { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }

        /// <summary>
        /// 是否外链
        /// </summary>
        public bool IsExternal { get; set; } = false;
    }
}