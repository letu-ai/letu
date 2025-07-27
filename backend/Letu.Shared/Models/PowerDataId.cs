using System.Diagnostics.CodeAnalysis;

namespace Letu.Shared.Models
{
    public class PowerDataId
    {
        /// <summary>
        /// 部门ID
        /// </summary>
        [NotNull]
        public List<Guid>? DeptIds { get; set; }

        /// <summary>
        /// 员工ID
        /// </summary>
        [NotNull]
        public List<Guid>? EmployeeIds { get; set; }
    }
}