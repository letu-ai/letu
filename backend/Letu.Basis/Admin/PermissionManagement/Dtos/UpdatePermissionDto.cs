using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.PermissionManagement.Dtos;

public class UpdatePermissionDto
{
    [Required]
    public required string Name { get; set; }

    public bool IsGranted { get; set; }
}
