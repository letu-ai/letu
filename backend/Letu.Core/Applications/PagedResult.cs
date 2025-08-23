namespace Letu.Core.Applications
{
    public class PagedResult<T> : PagedResultRequest
    {
        /// <summary>
        /// 分页后数据
        /// </summary>
        public List<T>? Items { get; set; }

        /// <summary>
        /// 总条目
        /// </summary>
        public long TotalCount { get; set; }

        public PagedResult()
        { }

        public PagedResult(long totalCount, List<T> items)
        {
            Items = items;
            TotalCount = totalCount;
        }

        public PagedResult(IPagination page)
        {
            Current = page.Current;
            PageSize = page.PageSize;
        }

        public PagedResult(IPagination page, long totalCount, List<T> items)
        {
            Current = page.Current;
            PageSize = page.PageSize;
            Items = items;
            TotalCount = totalCount;
        }
    }
}