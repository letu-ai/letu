using Fancyx.Shared.Interfaces;

namespace Fancyx.Shared.Models
{
    public class PageSearch : IPage
    {
        public int PageSize { get; set; }
        public int Current { get; set; }
    }
}