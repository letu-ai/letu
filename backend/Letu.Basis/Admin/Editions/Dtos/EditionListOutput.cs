namespace Letu.Basis.Admin.Editions.Dtos
{
    public class EditionListOutput
    {
        /// <summary>
        /// ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 版本名称
        /// </summary>
        public required string Name { get; set; }

        /// <summary>
        /// 租户数量
        /// </summary>
        public long TenantCount { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        public string? Description { get; set; }

        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreationTime { get; set; }
    }
} 