namespace Fancyx.Admin.IService.System.Dtos
{
    public class MenuOptionTreeDto : AppOptionTree
    {
        public string? Key { get; set; }

        /// <summary>
        /// 子集
        /// </summary>
        public new List<MenuOptionTreeDto>? Children { get; set; }
    }
}