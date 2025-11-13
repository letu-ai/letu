using Letu.Shared.Consts;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Auditing;

namespace Letu.Basis.Admin.Users.Dtos
{
    public class UserCreateInput
    {
        /// <summary>
        /// 用户名（大小写字母，数字，下划线，长度3-12位）
        /// </summary>
        [StringLength(32, MinimumLength = 3)]
        [RegularExpression(RegexConsts.UserName)]
        public required string UserName { get; set; }

        /// <summary>
        /// 密码
        /// </summary>
        [MinLength(6)]
        [RegularExpression(RegexConsts.Password)]
        [DisableAuditing]
        public required string Password { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        [MaxLength(256)]
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
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