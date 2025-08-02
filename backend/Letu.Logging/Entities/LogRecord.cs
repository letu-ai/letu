using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Logging.Entities
{
    [Table(Name = "log_record")]
    public class LogRecord : CreationAuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 日志类型
        /// </summary>
        [Column(IsNullable = false)]
        public string? Type { get; set; } = null!;

        /// <summary>
        /// 日志子类型
        /// </summary>
        [Column(IsNullable = false)]
        public string? SubType { get; set; } = null!;

        /// <summary>
        /// 业务编号/ID
        /// </summary>
        [Column(IsNullable = false)]
        public string? BizNo { get; set; } = null!;

        /// <summary>
        /// 操作内容
        /// </summary>
        [Column(IsNullable = false)]
        public string? Content { get; set; } = null!;

        /// <summary>
        /// 浏览器
        /// </summary>
        [StringLength(512)]
        public string? Browser { get; set; }

        /// <summary>
        /// IP
        /// </summary>
        [StringLength(32)]
        public string? Ip { get; set; }

        /// <summary>
        /// 跟踪ID (用于关联一次请求的所有日志)
        /// </summary>
        public string? TraceId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        public Guid? TenantId { get; set; }

        /// <summary>
        /// 用户ID
        /// </summary>
        public Guid? UserId { get; set; }

        /// <summary>
        /// 用户名
        /// </summary>
        public string? UserName { get; set; }
    }
}