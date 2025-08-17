using System.Collections.Generic;

namespace Letu.Basis.Admin.PermissionManagement.Dtos;

public class GetPermissionListResultDto
{
    public string EntityDisplayName { get; set; }

    public List<PermissionGroupDto> Groups { get; set; }
}
