using Letu.Basis.Admin.Menus.Dtos;

namespace Letu.Basis.Admin.Menus
{
    public interface IMenuItemAppService
    {
        /// <summary>
        /// 新增菜单
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task AddMenuAsync(MenuItemCreateOrUpdateInput dto);

        /// <summary>
        /// 获取界面导航用的菜单
        /// </summary>
        /// <param name="applicationName"></param>
        /// <returns></returns>
        Task<List<NavigationMenuDto>> GetNavigationMenuAsync(string applicationName);

        /// <summary>
        /// 菜单树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<MenuItemListOutput>> GetMenuListAsync(MenuItemListInput dto);

        /// <summary>
        /// 修改菜单
        /// </summary>
        /// <param name="id"></param>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task UpdateMenuAsync(Guid id, MenuItemCreateOrUpdateInput dto);

        /// <summary>
        /// 删除菜单
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        Task DeleteMenusAsync(Guid[] ids);

        /// <summary>
        /// 获取菜单组成的选项树
        /// </summary>
        /// <param name="onlyFolder">true:只要目录</param>
        /// <param name="applicationName">菜单类型</param>
        /// <returns></returns>
        Task<List<MenuTreeSelectOption>> GetMenuOptionsAsync(bool onlyFolder, string applicationName);
    }
}