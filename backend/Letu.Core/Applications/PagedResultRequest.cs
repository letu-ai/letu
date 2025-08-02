namespace Letu.Applications
{
    public class PagedResultRequest : IPagination
    {
        public int PageSize { get; set; }
        public int Current { get; set; }
    }
}