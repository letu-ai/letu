using System.Collections.Generic;

namespace Letu.Basis.Admin.FeatureManagement.Dtos;

public class GetFeatureListResultDto
{
    public List<FeatureGroupDto> Groups { get; set; }
}
