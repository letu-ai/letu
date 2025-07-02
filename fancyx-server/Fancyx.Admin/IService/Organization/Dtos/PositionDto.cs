using System.ComponentModel.DataAnnotations;

namespace Fancyx.Admin.IService.Organization.Dtos
{
    public class PositionDto
    {
        public Guid? Id { get; set; }

        /// <summary>
        /// 职位名称
        /// </summary>
        [Required]
        public string? Name { get; set; }

        /// <summary>
        /// 职位编号
        /// </summary>
        public string? Code { get; set; }

        /// <summary>
        /// 职级
        /// </summary>
        [Required]
        public int Level { get; set; }

        /// <summary>
        /// 状态：1正常2停用
        /// </summary>
        [Required]
        public int Status { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        public string? Description { get; set; }

        /// <summary>
        /// 职位分组
        /// </summary>
        public Guid? GroupId { get; set; }
    }
}