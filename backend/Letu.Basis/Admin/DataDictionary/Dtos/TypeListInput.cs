using Letu.Applications;

namespace Letu.Basis.Admin.DataDictionary.Dtos;

public class TypeListInput : PagedResultRequest
{
    public string? Name { get; set; }

    public string? DictType { get; set; }
}