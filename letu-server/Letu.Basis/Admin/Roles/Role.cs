using Letu.Core.Interfaces;
using Letu.Repository.BaseEntity;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Letu.Basis.Admin.Roles.Dtos;

namespace Letu.Basis.Admin.Roles
{
    /// <summary>
    /// 角色表
    /// </summary>
    [Table(Name = "sys_role")]
    public class Role : FullAuditedEntity, ITenant
    {
        /// <summary>
        /// 角色名
        /// </summary>
        [NotNull]
        [StringLength(64)]
        [Column(IsNullable = false, StringLength = 64)]
        public string? RoleName { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [StringLength(512)]
        [Column(StringLength = 512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 用户角色
        /// </summary>
        public virtual ICollection<UserInRole>? Users { get; set; }

        /// <summary>
        /// 角色菜单
        /// </summary>
        public virtual ICollection<MenuInRole>? Menus { get; set; }

        /// <summary>
        /// 角色查看部门（数据权限类型=1时，指定部门时才存入）
        /// </summary>
        public virtual ICollection<DepartmentInRole>? Departments { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [Column(IsNullable = false)]
        public bool IsEnabled { get; set; } = false;
    }
}