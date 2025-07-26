using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Employees.Dtos
{
    public class EmployeeBindUserDto
    {
        public Guid? UserId { get; set; }

        [Required]
        public Guid EmployeeId { get; set; }
    }
}