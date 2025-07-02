using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.Entities.System
{
    [Table(Name = "sys_notification")]
    public class NotificationDO : AuditedEntity, ITenant
    {
        /// <summary>
        /// 通知标题
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(100)]
        [Column(IsNullable = false)]
        public string? Title { get; set; }

        /// <summary>
        /// 通知描述
        /// </summary>
        [MaxLength(500)]
        public string? Description { get; set; }

        /// <summary>
        /// 通知员工
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false)]
        public Guid EmployeeId { get; set; }

        /// <summary>
        /// 是否已读(1已读0未读)
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public bool IsReaded { get; set; }

        /// <summary>
        /// 已读时间
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public DateTime? ReadedTime { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}