using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Departments;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.OrganizationUnits;
using Letu.Basis.Admin.UserTags;

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
            UserName = "";
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
        [Navigate(ManyToMany = typeof(UserInRole))]
        public virtual ICollection<Role>? Roles { get; set; }

        /// <summary>
        /// 用户标签
        /// </summary>
        [Navigate(ManyToMany = typeof(UserInTag))]
        public virtual ICollection<UserTag>? Tags { get; set; }

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
        /// 所属部门
        /// </summary>
        [Navigate(nameof(DepartmentId))]
        public Department? Department { get; set; }

        /// <summary>
        /// 职位ID
        /// </summary>
        public Guid? PositionId { get; set; }

        /// <summary>
        /// 所属职位
        /// </summary>
        [Navigate(nameof(PositionId))]
        public Position? Position { get; set; }

        /// <summary>
        /// 关联员工ID
        /// </summary>
        public Guid? EmployeeId { get; set; }

        /// <summary>
        /// 关联员工
        /// </summary>
        [Navigate(nameof(EmployeeId))]
        public Employee? Employee { get; set; }

        /// <summary>
        /// 组织单元ID
        /// </summary>
        public Guid? OrganizationUnitId { get; set; }

        /// <summary>
        /// 所属组织单元
        /// </summary>
        [Navigate(nameof(OrganizationUnitId))]
        public OrganizationUnit? OrganizationUnit { get; set; }
    }
}