using System.ComponentModel.DataAnnotations;
using Volo.Abp.Auditing;

namespace Letu.Basis.Admin.SettingManagement.Dtos;

public class UpdateEmailSettingsDto : IValidatableObject
{
    [MaxLength(256)]
    public required  string SmtpHost { get; set; }

    [Range(1, 65535)]
    public int SmtpPort { get; set; }

    [MaxLength(1024)]
    public string? SmtpUserName { get; set; }

    [MaxLength(1024)]
    [DataType(DataType.Password)]
    [DisableAuditing]
    public string? SmtpPassword { get; set; }

    [MaxLength(1024)]
    public string? SmtpDomain { get; set; }

    public bool SmtpEnableSsl { get; set; }

    public bool SmtpUseDefaultCredentials { get; set; }

    [MaxLength(1024)]
    [Required]
    public required string DefaultFromAddress { get; set; }

    [MaxLength(1024)]
    [Required]
    public required string DefaultFromDisplayName { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        // 当不使用默认凭据时，必须填写用户名、密码和域名
        if (!SmtpUseDefaultCredentials)
        {
            if (string.IsNullOrWhiteSpace(SmtpUserName))
            {
                yield return new ValidationResult(
                    "当不使用默认凭据时，SMTP用户名为必填项", 
                    new[] { nameof(SmtpUserName) });
            }

            if (string.IsNullOrWhiteSpace(SmtpPassword))
            {
                yield return new ValidationResult(
                    "当不使用默认凭据时，SMTP密码为必填项", 
                    new[] { nameof(SmtpPassword) });
            }
        }
    }
}

