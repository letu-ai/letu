namespace Letu.Basis.Admin.Departments.Dtos
{
    public class DeptEmployeeTreeOutput
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
        public List<DeptEmployeeTreeOutput>? Children { get; set; }

        /// <summary>
        /// 是否禁用
        /// </summary>
        public bool Disabled => Type == 1;
    }
}