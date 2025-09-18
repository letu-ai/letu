using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users
{
    /// <summary>
    /// 用户表
    /// </summary>
    [Table(Name = "sys_user")]
    public class User : FullAuditedEntity<Guid>, IMultiTenant
    {
        //public User()
        //{
        //}

        protected User()
        {
        }

        public User(Guid id, string userName) : base(id)
        {
            UserName = userName;
        }

        /// <summary>
        /// 用户名
        /// </summary>
        [StringLength(32)]
        [Column(IsNullable = false, StringLength = 32)]
        public string UserName { get; set; }

        /// <summary>
        /// 密码哈希
        /// </summary>
        [StringLength(512)]
        [Column(IsNullable = false, StringLength = 512)]
        public required string PasswordHash { get; set; }

        /// <summary>
        /// 密码盐
        /// </summary>
        [StringLength(256)]
        [Column(IsNullable = false, StringLength = 256)]
        public required string PasswordSalt { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        [StringLength(256)]
        [Column(IsNullable = true, StringLength = 256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        [Required]
        [StringLength(32)]
        [Column(IsNullable = false, StringLength = 32)]
        public required string NickName { get; set; }


        /// <summary>
        /// 是否启用
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public bool IsEnabled { get; set; }

        /// <summary>
        /// 用户角色
        /// </summary>
        public virtual ICollection<UserInRole>? Roles { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }

        /// <summary>
        /// 手机号码
        /// </summary>
        [StringLength(16)]
        [Column(StringLength = 16)]
        public string? Phone { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        [StringLength(64)]
        [EmailAddress]
        [Column(StringLength = 64)]
        public string? Email { get; set; }

        /// <summary>
        /// 部门ID
        /// </summary>
        public Guid? DepartmentId { get; set; }

        /// <summary>
        /// 职位ID
        /// </summary>
        public Guid? PositionId { get; set; }

        /// <summary>
        /// 关联员工ID
        /// </summary>
        public Guid? EmployeeId { get; set; }

        /// <summary>
        /// 组织单元ID
        /// </summary>
        public Guid? OrganizationUnitId { get; set; }
    }
}