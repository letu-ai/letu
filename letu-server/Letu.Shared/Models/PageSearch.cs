using Letu.Shared.Interfaces;

namespace Letu.Shared.Models
{
    public class PageSearch : IPage
    {
        public int PageSize { get; set; }
        public int Current { get; set; }
    }
}