namespace Letu.Basis.Admin.PermissionManagement.Dtos;

public class PermissionGroupDto
{
    public required string Name { get; set; }

    public required string DisplayName { get; set; }

    public required List<PermissionGrantInfoDto> Permissions { get; set; }
}
