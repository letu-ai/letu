namespace Letu.Basis.Admin.UserTags.Dtos
{
    /// <summary>
    /// 用户标签简要信息（用于用户列表展示）
    /// </summary>
    public class UserTagInfo
    {
        /// <summary>
        /// 标签ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 标签名称
        /// </summary>
        public required string Name { get; set; }

        /// <summary>
        /// 标签颜色
        /// </summary>
        public string? Color { get; set; }
    }
}