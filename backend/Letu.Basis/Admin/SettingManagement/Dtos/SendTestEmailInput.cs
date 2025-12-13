using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.SettingManagement.Dtos;

public class SendTestEmailInput
{
    [Required]
    public required string SenderEmailAddress { get; set; }

    [Required]
    public required string TargetEmailAddress { get; set; }

    [Required]
    public required string Subject { get; set; }
    
    public string? Body { get; set; }
}