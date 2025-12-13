using Letu.Basis.Admin.UserTags.Dtos;

namespace Letu.Basis.Admin.Users.Dtos
{
    public class UserListOutput
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 用户名
        /// </summary>
        public string? UserName { get; set; }

        /// <summary>
        /// 头像
        /// </summary>
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        public string? NickName { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        public bool IsEnabled { get; set; }

        /// <summary>
        /// 手机号
        /// </summary>
        public string? Phone { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        public string? Email { get; set; }

        /// <summary>
        /// 部门ID
        /// </summary>
        public Guid? DepartmentId { get; set; }

        /// <summary>
        /// 部门名称
        /// </summary>
        public string? DepartmentName { get; set; }

        /// <summary>
        /// 职位ID
        /// </summary>
        public Guid? PositionId { get; set; }

        /// <summary>
        /// 职位名称
        /// </summary>
        public string? PositionName { get; set; }

        /// <summary>
        /// 关联员工ID
        /// </summary>
        public Guid? EmployeeId { get; set; }

        /// <summary>
        /// 员工姓名
        /// </summary>
        public string? EmployeeName { get; set; }

        /// <summary>
        /// 组织单元ID
        /// </summary>
        public Guid? OrganizationUnitId { get; set; }

        /// <summary>
        /// 组织单元名称
        /// </summary>
        public string? OrganizationUnitName { get; set; }

        /// <summary>
        /// 用户标签列表
        /// </summary>
        public List<UserTagInfo>? Tags { get; set; }

        public List<string>? Roles { get; set; }


        public string? Description { get; set; }
    }
}