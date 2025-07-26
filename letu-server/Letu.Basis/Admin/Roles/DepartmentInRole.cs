using Letu.Repository.BaseEntity;
using Letu.Core.Interfaces;
using FreeSql.DataAnnotations;

namespace Letu.Basis.Admin.Roles
{
    [Table(Name = "sys_role_dept")]
    public class DepartmentInRole : Entity, ITenant
    {
        /// <summary>
        /// 角色ID
        /// </summary>
        [Column(IsPrimary = true, IsNullable = false)]
        public Guid RoleId { get; set; }

        /// <summary>
        /// 部门ID
        /// </summary>
        [Column(IsPrimary = true, IsNullable = false)]
        public Guid DeptId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}