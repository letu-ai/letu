namespace Letu.Basis.Admin.Positions.Dtos
{
    public class PositionGroupQueryDto : PageSearch
    {
        /// <summary>
        /// 分组名
        /// </summary>
        public string? GroupName { get; set; }
    }
}