namespace Letu.Basis.Admin.Settings.Dtos
{
    public class ConfigQueryDto : PageSearch
    {
        public string? Name { get; set; }
        public string? Key { get; set; }
    }
}