using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Roles.Dtos
{
    public class RoleCreateOrUpdateInput
    {
        /// <summary>
        /// 角色名
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(64)]
        public required string Name { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [MaxLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 新建用户默认分配的角色
        /// </summary>
        public bool IsDefault { get; set; }

        /// <summary>
        /// 用户可以查看其他用户的公共角色。一些特殊角色如“超级管理员”不允许被设置为公共角色。
        /// </summary>
        public bool IsPublic { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [NotNull]
        [Required]
        public bool IsEnabled { get; set; }
    }
}