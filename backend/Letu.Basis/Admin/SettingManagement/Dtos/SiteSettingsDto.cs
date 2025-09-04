using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.SettingManagement.Dtos;

public class SiteSettingsDto
{
    public string? Title { get; set; }
    public string? Favicon { get; set; }
    public string? Logo { get; set; } 
    public string? LogoText { get; set; }
    public string? Copyright { get; set; }
    public string? Icp { get; set; } 
    public string? Description { get; set; } 
    public string? Keywords { get; set; } 
    
    public string? PrimaryColor { get; set; } 
}

