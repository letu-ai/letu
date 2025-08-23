using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Menus.Dtos
{
    public class MenuItemCreateOrUpdateInput
    {
        /// <summary>
        /// 显示标题/名称
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(32)]
        public string? Title { get; set; }

        /// <summary>
        /// 图标
        /// </summary>
        [MaxLength(64)]
        public string? Icon { get; set; }

        /// <summary>
        /// 路由/地址
        /// </summary>
        [MaxLength(256)]
        public string? Path { get; set; }

        [MaxLength(32)]
        public required string ApplicationName { get; set; }

        /// <summary>
        /// 功能类型
        /// </summary>
        public MenuType MenuType { get; set; }

        /// <summary>
        /// 父级ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 是否隐藏
        /// </summary>
        [Required]
        public bool Display { get; set; }

        public string[]? Permissions { get; set; }

        public string[]? Features { get; set; }

        /// <summary>
        /// 是否外链
        /// </summary>
        public bool IsExternal { get; set; }
    }
}