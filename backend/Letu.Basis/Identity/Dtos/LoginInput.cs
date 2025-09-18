using System.ComponentModel.DataAnnotations;
using Volo.Abp.Auditing;

namespace Letu.Basis.Identity.Dtos
{
    public class LoginInput
    {
        /// <summary>
        /// 用户名
        /// </summary>
        [Required]
        public required string UserName { get; set; }

        /// <summary>
        /// 密码
        /// </summary>
        [DisableAuditing]
        [Required]
        public required string Password { get; set; }
    }
}