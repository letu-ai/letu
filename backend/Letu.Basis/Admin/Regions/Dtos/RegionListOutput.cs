namespace Letu.Basis.Admin.Regions.Dtos
{
    public class RegionListOutput
    {
        public int Id { get; set; }

        /// <summary>
        /// 行政区域代码
        /// </summary>
        public string Code { get; set; }

        /// <summary>
        /// 区域名称
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// 中心点坐标
        /// </summary>
        public string? Center { get; set; }

        /// <summary>
        /// 级别：1省/直辖市，2市/州，3县/区，4街道/乡镇
        /// </summary>
        public int Level { get; set; }

        /// <summary>
        /// 父级ID
        /// </summary>
        public int? ParentId { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        public bool IsEnabled { get; set; }
    }
}