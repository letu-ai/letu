using Letu.Applications;
using Letu.Basis.Admin.Editions;
using Letu.Basis.Admin.Editions.Dtos;
using Letu.Basis.Permissions;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    /// <summary>
    /// 版本管理
    /// </summary>
    [ApiController]
    [Route("api/admin/editions")]
    [Authorize(BasisPermissions.Edition.Default)]
    public class EditionController : ControllerBase
    {
        private readonly IEditionAppService _editionAppService;

        public EditionController(IEditionAppService editionAppService)
        {
            _editionAppService = editionAppService;
        }

        /// <summary>
        /// 新增版本
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.Edition.Create)]
        public async Task AddEditionAsync([FromBody] EditionCreateOrUpdateInput dto)
        {
            await _editionAppService.AddEditionAsync(dto);
        }

        /// <summary>
        /// 版本列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<PagedResult<EditionListOutput>> GetEditionListAsync([FromQuery] EditionListInput dto)
        {
            return await _editionAppService.GetEditionListAsync(dto);
        }

        /// <summary>
        /// 修改版本
        /// </summary>
        /// <param name="id">版本ID</param>
        /// <param name="dto">版本信息</param>
        /// <returns></returns>
        [HttpPut]
        [Route("{id}")]
        [Authorize(BasisPermissions.Edition.Update)]
        public async Task UpdateEditionAsync([FromRoute] Guid id, [FromBody] EditionCreateOrUpdateInput dto)
        {
            await _editionAppService.UpdateEditionAsync(id, dto);
        }

        /// <summary>
        /// 删除版本
        /// </summary>
        /// <param name="id">版本ID</param>
        /// <returns></returns>
        [HttpDelete]
        [Route("{id}")]
        [Authorize(BasisPermissions.Edition.Delete)]
        public async Task DeleteEditionAsync([FromRoute] Guid id)
        {
            await _editionAppService.DeleteEditionAsync(id);
        }

        /// <summary>
        /// 获取版本下拉列表
        /// </summary>
        /// <returns>版本下拉列表数据</returns>
        [HttpGet]
        [Route("select-list")]
        public async Task<List<EditionInfoDto>> GetEditionSelectListAsync()
        {
            return await _editionAppService.GetEditionSelectListAsync();
        }
    }
}