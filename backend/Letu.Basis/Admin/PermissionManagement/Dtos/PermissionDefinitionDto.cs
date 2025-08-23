namespace Letu.Basis.Admin.PermissionManagement.Dtos;
public class PermissionDefinitionDto
{
    public PermissionDefinitionDto(string name, string displayName)
    {
        Name = name;
        DisplayName = displayName;
    }

    public string Name { get; }

    public string DisplayName { get; }

    public bool IsGroup { get; set; }

    public List<PermissionDefinitionDto> Permissions { get; set; } = new List<PermissionDefinitionDto>();
}
