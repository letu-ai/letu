namespace Letu.Basis.Admin.NotificationManagement
{
    /// <summary>
    /// 发送范围类型
    /// </summary>
    public enum SendScopeType
    {
        /// <summary>
        /// 指定用户
        /// </summary>
        SpecificUsers = 1,

        /// <summary>
        /// 按角色
        /// </summary>
        ByRole = 2,

        /// <summary>
        /// 按部门
        /// </summary>
        ByDepartment = 3,

        /// <summary>
        /// 按职位
        /// </summary>
        ByPosition = 4,

        /// <summary>
        /// 全体用户
        /// </summary>
        AllUsers = 5
    }
}