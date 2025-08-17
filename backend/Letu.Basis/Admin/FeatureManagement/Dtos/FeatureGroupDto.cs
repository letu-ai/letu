namespace Letu.Basis.Admin.FeatureManagement.Dtos;

public class FeatureGroupDto
{
    public required string Name { get; set; }

    public string? DisplayName { get; set; }

    public List<FeatureDto> Features { get; set; }

    public string GetNormalizedGroupName()
    {
        return Name.Replace(".", "_");
    }
}
