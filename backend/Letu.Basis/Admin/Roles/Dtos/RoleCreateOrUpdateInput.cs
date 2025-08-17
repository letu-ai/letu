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
        /// 是否启用
        /// </summary>
        [NotNull]
        [Required]
        public bool IsEnabled { get; set; }
    }
}