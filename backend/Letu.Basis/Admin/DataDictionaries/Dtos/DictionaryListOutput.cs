namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class DictionaryListOutput
{
    public Guid Id { get; set; }

    public required string Name { get; set; }

    public required string DisplayName { get; set; }

    public bool IsEnabled { get; set; }

    public string? Remark { get; set; }

    public DateTime CreationTime { get; set; }
}