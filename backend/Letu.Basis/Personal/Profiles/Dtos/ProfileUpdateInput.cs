using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Personal.Profiles.Dtos;

public class ProfileUpdateInput
{
    /// <summary>
    /// 头像
    /// </summary>
    [StringLength(256)]
    public string? Avatar { get; set; }

    /// <summary>
    /// 昵称
    /// </summary>
    [Required]
    [StringLength(32)]
    public required string NickName { get; set; }
}