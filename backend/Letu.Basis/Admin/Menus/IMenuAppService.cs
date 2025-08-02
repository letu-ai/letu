using Letu.Basis.Admin.Menus.Dtos;

namespace Letu.Basis.Admin.Menus
{
    public interface IMenuAppService
    {
        /// <summary>
        /// 新增菜单
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task AddMenuAsync(MenuCreateOrUpdateInput dto);

        /// <summary>
        /// 菜单树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<MenuListOutput>> GetMenuListAsync(MenuQueryDto dto);

        /// <summary>
        /// 修改菜单
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput dto);

        /// <summary>
        /// 删除菜单
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        Task DeleteMenusAsync(Guid[] ids);

        /// <summary>
        /// 获取菜单组成的选项树
        /// </summary>
        /// <param name="onlyMenu">true:只要目录+菜单</param>
        /// <param name="keyword">关键字筛选</param>
        /// <returns></returns>
        Task<(string[] keys, List<MenuOptionTreeDto> tree)> GetMenuOptionsAsync(bool onlyMenu, string? keyword);
    }
}