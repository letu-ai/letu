using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Admin.IService.System.Dtos
{
    public class ConfigDto
    {
        public Guid? Id { get; set; }

        [NotNull]
        [Required]
        public string? Name { get; set; }

        [NotNull]
        [Required]
        public string? Key { get; set; } = null!;

        [Required]
        public string? Value { get; set; } = null!;

        public string? GroupKey { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [StringLength(512)]
        public string? Remark { get; set; }
    }
}