using Letu.Core.Interfaces;
using Letu.Repository.BaseEntity;
using Letu.Shared.Enums;
using FreeSql.DataAnnotations;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Letu.Basis.Admin.Roles.Dtos;

namespace Letu.Basis.Admin.Users
{
    /// <summary>
    /// 用户表
    /// </summary>
    [Table(Name = "sys_user")]
    public class User : FullAuditedEntity, ITenant
    {
        /// <summary>
        /// 用户名
        /// </summary>
        [NotNull]
        [StringLength(32)]
        [Column(IsNullable = false, StringLength = 32)]
        public string? UserName { get; set; }

        /// <summary>
        /// 密码
        /// </summary>
        [NotNull]
        [StringLength(512)]
        [Column(IsNullable = false, StringLength = 512)]
        public string? Password { get; set; }

        /// <summary>
        /// 密码盐
        /// </summary>
        [NotNull]
        [StringLength(256)]
        [Column(IsNullable = false, StringLength = 256)]
        public string? PasswordSalt { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        [StringLength(256)]
        [Column(IsNullable = true, StringLength = 256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false, StringLength = 64)]
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
        public virtual ICollection<UserInRole>? UserRoles { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }

        /// <summary>
        /// 手机号码
        /// </summary>
        [Column(StringLength = 11)]
        public string? Phone { get; set; }
    }
}