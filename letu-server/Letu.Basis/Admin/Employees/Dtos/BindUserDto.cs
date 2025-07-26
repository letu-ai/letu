using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Employees.Dtos
{
    public class BindUserDto
    {
        /// <summary>
        /// 员工ID
        /// </summary>
        [Required]
        public Guid EmployeeId { get; set; }

        /// <summary>
        /// 用户ID
        /// </summary>
        [Required]
        public Guid UserId { get; set; }
    }
}