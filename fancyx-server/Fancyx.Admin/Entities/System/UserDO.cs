using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Fancyx.Shared.Enums;

namespace Fancyx.Admin.Entities.System
{
    /// <summary>
    /// 用户表
    /// </summary>
    [Table(Name = "sys_user")]
    public class UserDO : FullAuditedEntity, ITenant
    {
        /// <summary>
        /// 用户名
        /// </summary>
        [NotNull]
        [StringLength(32)]
        [Column(IsNullable = false)]
        public string? UserName { get; set; }

        /// <summary>
        /// 密码
        /// </summary>
        [NotNull]
        [StringLength(512)]
        [Column(IsNullable = false)]
        public string? Password { get; set; }

        /// <summary>
        /// 密码盐
        /// </summary>
        [NotNull]
        [StringLength(256)]
        [Column(IsNullable = false)]
        public string? PasswordSalt { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        [StringLength(256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false)]
        [StringLength(64)]
        public string? NickName { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        [NotNull]
        [Required]
        [Column(IsNullable = false)]
        [DefaultValue(0)]
        public SexType Sex { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public bool IsEnabled { get; set; }

        /// <summary>
        /// 用户角色
        /// </summary>
        public virtual ICollection<UserRoleDO>? UserRoles { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}