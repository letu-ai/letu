using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Positions.Dtos
{
    public class PositionGroupCreateOrUpdateInput
    {
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 分组名称
        /// </summary>
        [Required]
        [MaxLength(64)]
        public string? GroupName { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [MaxLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 排序值
        /// </summary>
        public int Sort { get; set; }
    }
}