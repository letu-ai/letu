using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.Entities.System
{
    /// <summary>
    /// 业务日志
    /// </summary>
    [Table(Name = "sys_business_log")]
    public class BusinessLogDO : CreationEntity, ITenant
    {
        /// <summary>
        /// 账号
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(32)]
        [Column(IsNullable = false)]
        public string? UserName { get; set; }

        /// <summary>
        /// 操作方法，全名
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(512)]
        [Column(IsNullable = false)]
        public string? Action { get; set; }

        /// <summary>
        /// http请求方式
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(16)]
        [Column(IsNullable = false)]
        public string? HttpMethod { get; set; }

        /// <summary>
        /// 请求地址
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(512)]
        [Column(IsNullable = false)]
        public string? Url { get; set; }

        /// <summary>
        /// 系统
        /// </summary>
        [StringLength(64)]
        public string? Os { get; set; }

        /// <summary>
        /// 浏览器
        /// </summary>
        [StringLength(64)]
        public string? Browser { get; set; }

        /// <summary>
        /// 操作节点名
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(128)]
        public string? NodeName { get; set; }

        /// <summary>
        /// IP
        /// </summary>
        [StringLength(32)]
        public string? Ip { get; set; }

        /// <summary>
        /// 登录地址
        /// </summary>
        [StringLength(256)]
        public string? Address { get; set; }

        /// <summary>
        /// 是否成功
        /// </summary>
        public bool IsSuccess { get; set; }

        /// <summary>
        /// 操作信息
        /// </summary>
        [StringLength(128)]
        public string? OperationMsg { get; set; }

        /// <summary>
        /// 耗时，单位毫秒
        /// </summary>
        public int MillSeconds { get; set; }

        /// <summary>
        /// 请求跟踪ID
        /// </summary>
        public string? RequestId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}