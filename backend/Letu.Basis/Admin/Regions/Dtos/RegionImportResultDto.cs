namespace Letu.Basis.Admin.Regions.Dtos
{
    /// <summary>
    /// 行政区域导入结果
    /// </summary>
    public class RegionImportResultDto
    {
        /// <summary>
        /// 导入的总记录数
        /// </summary>
        public int TotalCount { get; set; }

        /// <summary>
        /// 导入的省份数量
        /// </summary>
        public int ProvincesCount { get; set; }

        /// <summary>
        /// 导入的市级数量
        /// </summary>
        public int CitiesCount { get; set; }

        /// <summary>
        /// 导入的区县数量
        /// </summary>
        public int DistrictsCount { get; set; }

        /// <summary>
        /// 是否成功
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 错误消息（如果有）
        /// </summary>
        public string? ErrorMessage { get; set; }
    }
}