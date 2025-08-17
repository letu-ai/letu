namespace Letu.Basis.Admin.DataDictionary.Dtos
{
    public class ItemListOutput
    {
        /// <summary>
        /// 字典ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 字典值
        /// </summary>
        public required string Value { get; set; }

        /// <summary>
        /// 显示文本
        /// </summary>
        public required string Label { get; set; }

        /// <summary>
        /// 字典类型
        /// </summary>
        public required string DictType { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        public string? Remark { get; set; }

        /// <summary>
        /// 排序值
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 是否开启
        /// </summary>
        public bool IsEnabled { get; set; }

        public DateTime CreationTime { get; set; }
    }
}