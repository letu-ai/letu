using Letu.Applications;

namespace Letu.Basis.Admin.DataDictionary.Dtos;

public class DictTypeSearchDto : PagedResultRequest
{
    public string? Name { get; set; }

    public string? DictType { get; set; }
}