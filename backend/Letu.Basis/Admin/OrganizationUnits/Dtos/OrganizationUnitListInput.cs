using Letu.Core.Applications;

namespace Letu.Basis.Admin.OrganizationUnits.Dtos
{
    public class OrganizationUnitListInput : PagedResultRequest
    {
        /// <summary>
        /// 分类（用于机构种类）
        /// </summary>
        public string? Category { get; set; }

        /// <summary>
        /// 类型
        /// </summary>
        public string? Type { get; set; }

        /// <summary>
        /// 组织单元ID
        /// </summary>
        public Guid? Id { get; set; }

        /// <summary>
        /// 组织单元名称
        /// </summary>
        public string? Name { get; set; }

    }
}