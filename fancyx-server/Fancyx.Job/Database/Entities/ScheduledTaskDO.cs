using Fancyx.Repository.BaseEntity;
using FreeSql.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Job.Database.Entities
{
    /// <summary>
    /// 定时任务表实体
    /// </summary>
    [Table(Name = "scheduled_tasks")]
    [Index("uk_task_key", "task_key", true)]
    public class ScheduledTaskDO : AuditedEntity
    {
        /// <summary>
        /// 任务KEY（唯一标识）
        /// </summary>
        [NotNull]
        [Column(Name = "task_key", StringLength = 100, IsNullable = false)]
        public string? TaskKey { get; set; }

        /// <summary>
        /// 任务描述
        /// </summary>
        [Column(Name = "task_description", StringLength = -2)]
        public string? Description { get; set; }

        /// <summary>
        /// Cron表达式
        [NotNull]
        [Column(Name = "cron_expression", StringLength = 50, IsNullable = false)]
        public string? CronExpression { get; set; }

        /// <summary>
        /// 是否激活
        /// </summary>
        [Column(Name = "is_active")]
        public bool IsActive { get; set; } = false;
    }
}