using Letu.Shared.Enums;

namespace Letu.Basis.Account.Dtos
{
    public class UserInfoUpdateInput
    {
        /// <summary>
        /// 头像
        /// </summary>
        public string? Avatar { get; set; }

        /// <summary>
        /// 昵称
        /// </summary>
        public string? NickName { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        public SexType Sex { get; set; }
    }
}