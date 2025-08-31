using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.OrganizationUnits.Dtos
{
    public class OrganizationUnitCreateOrUpdateInput
    {
     
        /// <summary>
        /// 父ID
        /// </summary>
        public Guid? ParentId { get; set; }
        
        /// <summary>
        /// 组织单元名称
        /// </summary>
        [Required]
        [MaxLength(64)]
        public string? Name { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

    }
}