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
        [Column(IsNullable = false, StringLength = 32)]
        public string UserName { get; set; }

        /// <summary>
        /// 密码哈希
        /// </summary>
        [Column(IsNullable = false, StringLength = 512)]
        public required string PasswordHash { get; set; }

        /// <summary>
        /// 密码盐
        /// </summary>
        [Column(IsNullable = false, StringLength = 256)]
        public required string PasswordSalt { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        [Column(StringLength = 256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        [Column(IsNullable = false, StringLength = 32)]
        public required string NickName { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        [Column(StringLength = 256)]
        public string? Description { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [Column(IsNullable = false)]
        public bool IsEnabled { get; set; }

        /// <summary>
        /// 用户角色
        /// </summary>
        public virtual ICollection<UserInRole>? Roles { get; set; }

        /// <summary>
        /// 用户标签
        /// </summary>
        public virtual ICollection<UserInTag>? Tags { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(StringLength = 18)]
        public Guid? TenantId { get; set; }

        /// <summary>
        /// 手机号码
        /// </summary>
        [Column(StringLength = 16)]
        public string? Phone { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
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