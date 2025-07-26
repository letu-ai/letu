namespace Letu.Admin.IService.Organization.Dtos
{
    public class DeptEmployeeTreeDto
    {
        /// <summary>
        /// 名称
        /// </summary>
        public string? Label { get; set; }

        /// <summary>
        /// ID
        /// </summary>
        public string? Value { get; set; }

        /// <summary>
        /// 1部门2员工
        /// </summary>
        public int Type { get; set; }

        /// <summary>
        /// 子集
        /// </summary>
        public List<DeptEmployeeTreeDto>? Children { get; set; }

        /// <summary>
        /// 是否禁用
        /// </summary>
        public bool Disabled => Type == 1;
    }
}