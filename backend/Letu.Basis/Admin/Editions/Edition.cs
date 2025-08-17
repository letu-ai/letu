using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;

namespace Letu.Basis.Admin.Editions
{
    /// <summary>
    /// 版本表
    /// </summary>
    [Table(Name = "sys_edition")]
    public class Edition : FullAuditedEntity<Guid>
    {
        /// <summary>
        /// 版本名称
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false)]
        public string? Name { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        [StringLength(512)]
        public string? Description { get; set; }
    }
}