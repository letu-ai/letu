using Volo.Abp.Validation.StringValues;

namespace Letu.Basis.Admin.FeatureManagement.Dtos;

public class FeatureDto
{
    public  required string Name { get; set; }

    public string? DisplayName { get; set; }

    public string? Value { get; set; }

    public required FeatureProviderDto Provider { get; set; }

    public string? Description { get; set; }

    public IStringValueType? ValueType { get; set; }

    public int Depth { get; set; }

    public string? ParentName { get; set; }
}
