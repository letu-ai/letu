using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Tenants.Dtos;

public class TenantLogoUploadInput
{
    /// <summary>
    /// Logo文件
    /// </summary>
    [Required]
    public required IFormFile File { get; set; }
}