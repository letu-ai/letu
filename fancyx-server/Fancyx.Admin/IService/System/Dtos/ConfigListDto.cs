using System.ComponentModel.DataAnnotations;

namespace Fancyx.Admin.IService.System.Dtos
{
    public class ConfigListDto
    {
        public Guid? Id { get; set; }

        public string? Name { get; set; }

        public string? Key { get; set; } = null!;

        [Required]
        public string? Value { get; set; } = null!;

        public string? GroupKey { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        public string? Remark { get; set; }
    }
}
