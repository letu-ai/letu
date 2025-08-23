using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Basis.Permissions;

using Letu.Logging;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.MenuItem.Default)]
    [ApiController]
    [Route("api/admin/menus")]
    public class MenuItemController : ControllerBase
    {
        private readonly IMenuItemAppService _menuService;

        public MenuItemController(IMenuItemAppService menuService)
        {
            _menuService = menuService;
        }

        /// <summary>
        /// 新增菜单
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.MenuItem.Create)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task AddMenuAsync([FromBody] MenuItemCreateOrUpdateInput dto)
        {
            await _menuService.AddMenuAsync(dto);
        }

        /// <summary>
        /// 菜单树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [ApiAccessLog(operateType: [OperateType.Query])]
        public async Task<List<MenuItemListOutput>> GetMenuListAsync([FromQuery] MenuItemListInput dto)
        {
            return await _menuService.GetMenuListAsync(dto);
        }

        /// <summary>
        /// 修改菜单
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [Authorize(BasisPermissions.MenuItem.Update)]
        [ApiAccessLog(operateName: "修改菜单", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task UpdateMenuAsync(Guid id, [FromBody] MenuItemCreateOrUpdateInput input)
        {
            await _menuService.UpdateMenuAsync(id, input);
        }

        /// <summary>
        /// 删除菜单
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpDelete]
        [Authorize(BasisPermissions.MenuItem.Delete)]
        [ApiAccessLog(operateName: "删除菜单", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteMenusAsync([FromBody] Guid[] ids)
        {
            await _menuService.DeleteMenusAsync(ids);
        }

        /// <summary>
        /// 获取菜单组成的选项树
        /// </summary>
        /// <returns></returns>
        [HttpGet("{applicationName}/tree-options")]
        public async Task<List<MenuTreeSelectOption>> GetMenuOptionsAsync(bool onlyFolder, string applicationName)
        {
            return await _menuService.GetMenuOptionsAsync(onlyFolder, applicationName);
        }
    }
}