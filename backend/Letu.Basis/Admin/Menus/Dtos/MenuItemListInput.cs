using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Menus.Dtos
{
    public class MenuItemListInput
    {
        [MaxLength(32)]
        public required string ApplicationName { get; set; }

        /// <summary>
        /// 显示标题
        /// </summary>
        public string? Title { get; set; }

        /// <summary>
        /// 路由
        /// </summary>
        public string? Path { get; set; }
    }
}