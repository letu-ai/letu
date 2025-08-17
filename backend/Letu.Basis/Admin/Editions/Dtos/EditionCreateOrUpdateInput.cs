using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Editions.Dtos
{
    public class EditionCreateOrUpdateInput
    {
        /// <summary>
        /// 版本名称
        /// </summary>
        [NotNull]
        [Required(ErrorMessage = "版本名称不能为空")]
        [StringLength(64, ErrorMessage = "版本名称长度不能超过64个字符")]
        public string? Name { get; set; }

        /// <summary>
        /// 描述
        /// </summary>
        [StringLength(512, ErrorMessage = "描述长度不能超过512个字符")]
        public string? Description { get; set; }
    }
} 