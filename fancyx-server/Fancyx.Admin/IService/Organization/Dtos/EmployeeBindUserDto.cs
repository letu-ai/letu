using System.ComponentModel.DataAnnotations;

namespace Fancyx.Admin.IService.Organization.Dtos
{
    public class EmployeeBindUserDto
    {
        public Guid? UserId { get; set; }

        [Required]
        public Guid EmployeeId { get; set; }
    }
}