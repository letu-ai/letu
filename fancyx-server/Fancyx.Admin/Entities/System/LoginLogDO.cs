using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.Entities.System
{
    /// <summary>
    /// 登录日志
    /// </summary>
    [Table(Name = "sys_login_log")]
    public class LoginLogDO : CreationEntity, ITenant
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
        /// 浏览器
        /// </summary>
        [StringLength(512)]
        public string? Browser { get; set; }

        /// <summary>
        /// 操作信息
        /// </summary>
        [StringLength(128)]
        public string? OperationMsg { get; set; }

        /// <summary>
        /// 是否成功
        /// </summary>
        public bool IsSuccess { get; set; }

        /// <summary>
        /// 会话ID
        /// </summary>
        [StringLength(36)]
        public string? SessionId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}