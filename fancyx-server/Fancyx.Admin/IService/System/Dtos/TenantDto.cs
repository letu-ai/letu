using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.IService.System.Dtos
{
    public class TenantDto
    {
        public Guid? Id { get; set; }

        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        public string? Name { get; set; }

        /// <summary>
        /// 租户标识
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(18)]
        public string? TenantId { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        public string? Remark { get; set; }

        /// <summary>
        /// 租户域名
        /// </summary>
        public string? Domain { get; set; }
    }
}