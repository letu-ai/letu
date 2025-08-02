using System.ComponentModel.DataAnnotations;

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
        [Required]
        public required string Password { get; set; }
    }
}