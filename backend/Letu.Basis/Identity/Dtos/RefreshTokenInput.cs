using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Identity.Dtos;

public class RefreshTokenInput
{
    [Required]
    [StringLength(200, MinimumLength = 1)]
    public required string RefreshToken { get; set; }
}

