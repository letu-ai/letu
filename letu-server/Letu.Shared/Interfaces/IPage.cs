namespace Letu.Shared.Interfaces
{
    public interface IPage
    {
        int Current { get; set; }
        int PageSize { get; set; }
    }
}