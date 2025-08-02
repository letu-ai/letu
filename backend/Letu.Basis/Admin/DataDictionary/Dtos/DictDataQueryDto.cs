using Letu.Applications;

namespace Letu.Basis.Admin.DataDictionary.Dtos
{
    public class DictDataQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 字典标签
        /// </summary>
        public string? Label { get; set; }

        /// <summary>
        /// 字典类型
        /// </summary>
        public string? DictType { get; set; }
    }
}