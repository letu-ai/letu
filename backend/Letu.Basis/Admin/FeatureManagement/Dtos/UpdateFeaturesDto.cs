using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.FeatureManagement.Dtos;

public class UpdateFeaturesDto
{
    [Required]
    public required List<UpdateFeatureDto> Features { get; set; }
}
