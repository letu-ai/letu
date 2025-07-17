using Fancyx.Repository.BaseEntity;
using FreeSql.DataAnnotations;

namespace Fancyx.Job.Database.Entities
{
    /// <summary>
    /// 任务执行日志表实体
    /// </summary>
    [Table(Name = "task_execution_logs")]
    [Index("idx_task_key", "task_key")]
    [Index("idx_execution_time", "execution_time")]
    public class TaskExecutionLogDO : CreationEntity
    {
        /// <summary>
        /// 任务KEY
        /// </summary>
        [Column(Name = "task_key", StringLength = 100)]
        public string? TaskKey { get; set; }

        /// <summary>
        /// 执行状态（1:成功 2:失败）
        /// </summary>
        [Column(Name = "status")]
        public int Status { get; set; }

        /// <summary>
        /// 执行结果或错误信息
        /// </summary>
        [Column(Name = "result", DbType = "text")]
        public string? Result { get; set; }

        /// <summary>
        /// 服务器节点标识
        /// </summary>
        [Column(Name = "node_id", StringLength = 50)]
        public string? NodeId { get; set; }

        /// <summary>
        /// 执行时间
        /// </summary>
        public DateTime ExecutionTime { get; set; }

        /// <summary>
        /// 耗时（单位毫秒）
        /// </summary>
        public int Cost { get; set; }
    }
}