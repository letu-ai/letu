using Letu.Applications;

namespace Letu.Basis.Admin.Positions.Dtos
{
    public class PositionGroupListInput : PagedResultRequest
    {
        /// <summary>
        /// 分组名
        /// </summary>
        public string? GroupName { get; set; }
    }
}