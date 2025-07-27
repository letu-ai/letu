using Letu.Repository.BaseEntity;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Tenants
{
    [Index("uk_tenant_id", nameof(TenantId), true)]
    [Table(Name = "sys_tenant")]
    public class Tenant : AuditedEntity
    {
        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false, StringLength = 64)]
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
        [Column(StringLength = 512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 租户域名
        /// </summary>
        [Column(StringLength = 256)]
        public string? Domain { get; set; }
    }
}