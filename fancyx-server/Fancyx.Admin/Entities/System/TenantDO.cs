using Fancyx.Repository.BaseEntity;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.Entities.System
{
    [Index("uk_tenant_id", nameof(TenantId), true)]
    [Table(Name = "sys_tenant")]
    public class TenantDO : AuditedEntity
    {
        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false)]
        public string? Name { get; set; }

        /// <summary>
        /// 租户标识
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(18)]
        [Column(IsNullable = false, StringLength = 18)]
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