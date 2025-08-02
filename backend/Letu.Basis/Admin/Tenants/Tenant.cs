using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;

namespace Letu.Basis.Admin.Tenants
{
    [Table(Name = "sys_tenant")]
    public class Tenant : AuditedEntity<Guid>
    {
        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false, StringLength = 64)]
        public required string Name { get; set; }

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