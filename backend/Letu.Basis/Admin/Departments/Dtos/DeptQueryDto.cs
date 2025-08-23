using Letu.Core.Applications;

namespace Letu.Basis.Admin.Departments.Dtos
{
    public class DeptQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        public Guid? Id { get; set; }

        /// <summary>
        /// 部门编号
        /// </summary>
        public string? Code { get; set; }

        /// <summary>
        /// 部门名称
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// 状态：1正常2停用
        /// </summary>
        public int Status { get; set; }
    }
}