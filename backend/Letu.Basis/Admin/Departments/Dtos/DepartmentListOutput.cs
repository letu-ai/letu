using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Departments.Dtos
{
    public class DepartmentListOutput
    {
        public Guid Id { get; set; }

        /// <summary>
        /// 部门编号
        /// </summary>
        public string? Code { get; set; }

        /// <summary>
        /// 部门名称
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        [StringLength(512)]
        public string? Description { get; set; }

        /// <summary>
        /// 状态：1正常2停用
        /// </summary>
        public int Status { get; set; }

        /// <summary>
        /// 负责人
        /// </summary>
        public Guid? CuratorId { get; set; }

        /// <summary>
        /// 负责人姓名
        /// </summary>
        public string? CuratorName { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        public string? Email { get; set; }

        /// <summary>
        /// 电话
        /// </summary>
        public string? Phone { get; set; }

        /// <summary>
        /// 父ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 层级父ID
        /// </summary>
        public string? ParentIds { get; set; }

        /// <summary>
        /// 层级
        /// </summary>
        public int Layer { get; set; }

        /// <summary>
        /// 子集
        /// </summary>
        public List<DepartmentListOutput>? Children { get; set; }
    }
}