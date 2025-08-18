using Letu.Applications;

namespace Letu.Basis.Admin.Positions.Dtos
{
    public class PositionListInput : PagedResultRequest
    {
        /// <summary>
        /// 职位名称/编号
        /// </summary>
        public string? Keyword { get; set; }

        /// <summary>
        /// 职级
        /// </summary>
        public int Level { get; set; }

        /// <summary>
        /// 状态：1正常2停用
        /// </summary>
        public int? Status { get; set; }

        /// <summary>
        /// 职位分组
        /// </summary>
        public Guid? GroupId { get; set; }
    }
}