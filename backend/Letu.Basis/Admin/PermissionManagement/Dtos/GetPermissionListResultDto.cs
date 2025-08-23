namespace Letu.Basis.Admin.PermissionManagement.Dtos;

public class GetPermissionListResultDto
{
    public required string EntityDisplayName { get; set; }

    public required List<PermissionGroupDto> Groups { get; set; }
}
