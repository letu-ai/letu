using Letu.Shared.Consts;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Account.Dtos
{
    public class ChangePasswordInput
    {
        /// <summary>
        /// 旧密码。
        /// 通过手机、微信等途径注册的用户，旧密码为空。所以这里允许为空。
        /// </summary>
        public string? OldPassword { get; set; }

        /// <summary>
        /// 新密码
        /// </summary>
        [Required]
        [StringLength(32, MinimumLength = 6)]
        public required string NewPassword { get; set; }
    }
}