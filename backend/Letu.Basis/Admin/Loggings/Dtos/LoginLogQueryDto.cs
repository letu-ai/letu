using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings.Dtos
{
    public class LoginLogQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 账号
        /// </summary>
        public string? UserName { get; set; }

        /// <summary>
        /// 是否成功 0全部1成功2失败
        /// </summary>
        public int Status { get; set; }

        /// <summary>
        /// 登录地址
        /// </summary>
        public string? Address { get; set; }
    }
}