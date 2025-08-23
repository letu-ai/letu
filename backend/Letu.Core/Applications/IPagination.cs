namespace Letu.Core.Applications
{
    public interface IPagination
    {
        int Current { get; set; }
        int PageSize { get; set; }
    }
}