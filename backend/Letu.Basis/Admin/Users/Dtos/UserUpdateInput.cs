using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Users.Dtos
{
    public class UserUpdateInput
    {
        /// <summary>
        /// 头像
        /// </summary>
        [MaxLength(256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        [Required]
        [MaxLength(64)]
        public required string NickName { get; set; }

        /// <summary>
        /// 手机号
        /// </summary>
        [Phone]
        [StringLength(16)]
        public string? Phone { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        [EmailAddress]
        [StringLength(64)]
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

        /// <summary>
        /// 标签ID列表
        /// </summary>
        public List<Guid>? TagIds { get; set; }
    }
}