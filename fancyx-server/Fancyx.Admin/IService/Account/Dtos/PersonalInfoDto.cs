using Fancyx.Shared.Enums;

namespace Fancyx.Admin.IService.Account.Dtos
{
    public class PersonalInfoDto
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