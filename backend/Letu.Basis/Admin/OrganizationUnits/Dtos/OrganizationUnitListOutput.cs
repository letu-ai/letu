using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.OrganizationUnits.Dtos
{
    public class OrganizationUnitListOutput
    {
        public Guid Id { get; set; }

        /// <summary>
        /// 组织机构名称（同级唯一，忽略大小写）
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 上级ID
        /// </summary>
        public Guid? ParentId { get; set; }
    }
}
