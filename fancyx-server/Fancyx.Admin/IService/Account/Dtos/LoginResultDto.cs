namespace Fancyx.Admin.IService.Account.Dtos
{
    public class LoginResultDto : TokenResultDto
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        public Guid UserId { get; set; }

        /// <summary>
        /// 用户名
        /// </summary>
        public string? UserName { get; set; }

        /// <summary>
        /// 权限
        /// </summary>
        public string[]? Auths { get; set; }

        /// <summary>
        /// 角色
        /// </summary>
        public string[]? Roles { get; set; }
    }
}