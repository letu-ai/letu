using Letu.Repository.BaseEntity;
using Letu.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Notifications
{
    [Table(Name = "sys_notification")]
    public class Notification : AuditedEntity, ITenant
    {
        /// <summary>
        /// 通知标题
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(128)]
        [Column(IsNullable = false, StringLength = 128)]
        public string? Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        [MaxLength(512)]
        [Column(StringLength = 512)]
        public string? Content { get; set; }

        /// <summary>
        /// 通知员工
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false)]
        public Guid EmployeeId { get; set; }

        /// <summary>
        /// 是否已读(true已读false未读)
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