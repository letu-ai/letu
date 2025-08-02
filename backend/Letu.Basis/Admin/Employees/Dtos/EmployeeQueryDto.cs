using Letu.Applications;

namespace Letu.Basis.Admin.Employees.Dtos
{
    public class EmployeeQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 姓名/手机号/工号
        /// </summary>
        public string? Keyword { get; set; }

        /// <summary>
        /// 部门ID
        /// </summary>
        public Guid? DeptId { get; set; }
    }
}