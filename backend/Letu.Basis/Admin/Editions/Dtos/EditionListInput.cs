using Letu.Core.Applications;

namespace Letu.Basis.Admin.Editions.Dtos
{
    public class EditionListInput : PagedResultRequest
    {
        /// <summary>
        /// 版本名称
        /// </summary>
        public string? Name { get; set; }
    }
}