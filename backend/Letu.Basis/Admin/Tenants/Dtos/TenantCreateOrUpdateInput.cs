using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Tenants.Dtos
{
    public class TenantCreateOrUpdateInput
    {
        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(64)]
        public string? Name { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [MaxLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 租户域名
        /// </summary>
        [MaxLength(256)]
        public string? Domain { get; set; }
    }
}