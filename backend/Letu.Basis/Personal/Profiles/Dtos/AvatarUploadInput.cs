using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace Letu.Basis.Personal.Profiles.Dtos;

public class AvatarUploadInput : IValidatableObject
{
    [Required]
    public required IFormFile Avatar { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (Avatar == null)
        {
            // TODO: 定义常量
            if (Avatar?.Length > 1024 * 1024 * 2)
            {
                yield return new ValidationResult("头像文件过大", [nameof(Avatar)]);
            }

            if (Avatar?.ContentType != "image/png" && Avatar?.ContentType != "image/jpeg")
            {
                yield return new ValidationResult("头像只支持png和jpeg格式", [nameof(Avatar)]);
            }
        }
    }
}

