using Letu.Core.Applications;

namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class DictionaryListInput : PagedResultRequest
{
    public string? Keywords { get; set; }

}