using Letu.Applications;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Positions.Dtos;
using Letu.Core.Attributes;
using Letu.Logging;
using Letu.Shared.Consts;
using Letu.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/positions")]
    public class PositionController : ControllerBase
    {
        private readonly IPositionAppService _positionService;

        public PositionController(IPositionAppService positionService)
        {
            _positionService = positionService;
        }

        #region 职位管理

        /// <summary>
        /// 新增职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [HasPermission("Org.Position.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task CreatePositionAsync([FromBody] PositionCreateOrUpdateInput dto)
        {
            await _positionService.AddPositionAsync(dto);
        }

        /// <summary>
        /// 职位分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Org.Position.List")]
        public async Task<PagedResult<PositionListOutput>> GetPositionsAsync([FromQuery] PositionListInput dto)
        {
            return await _positionService.GetPositionListAsync(dto);
        }

        /// <summary>
        /// 修改职位
        /// </summary>
        /// <param name="id">职位ID</param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [HasPermission("Org.Position.Update")]
        public async Task UpdatePositionAsync(Guid id, [FromBody] PositionCreateOrUpdateInput dto)
        {
            await _positionService.UpdatePositionAsync(id, dto);
        }

        /// <summary>
        /// 删除职位
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [HasPermission("Org.Position.Delete")]
        [ApiAccessLog(operateName: "删除职位", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeletePositionAsync(Guid id)
        {
            await _positionService.DeletePositionAsync(id);
        }

        /// <summary>
        /// 职位分组+职位树
        /// </summary>
        /// <returns></returns>
        [HttpGet("tree")]
        public async Task<List<AppOptionTree>> GetPositionTreeAsync()
        {
            return await _positionService.GetPositionTreeOptionAsync();
        }

        #endregion

        #region 职位分组管理

        /// <summary>
        /// 新增职位分组
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("groups")]
        [HasPermission("Org.PositionGroup.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task CreatePositionGroupAsync([FromBody] PositionGroupCreateOrUpdateInput dto)
        {
            await _positionService.AddPositionGroupAsync(dto);
        }

        /// <summary>
        /// 职位分组分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("groups")]
        [HasPermission("Org.PositionGroup.List")]
        public async Task<List<PositionGroupListOutput>> GetPositionGroupsAsync([FromQuery] PositionGroupListInput dto)
        {
            return await _positionService.GetPositionGroupListAsync(dto);
        }

        /// <summary>
        /// 修改职位分组
        /// </summary>
        /// <param name="id">职位分组ID</param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("groups/{id}")]
        [HasPermission("Org.PositionGroup.Update")]
        public async Task UpdatePositionGroupAsync(Guid id, [FromBody] PositionGroupCreateOrUpdateInput dto)
        {
            await _positionService.UpdatePositionGroupAsync(id, dto);
        }

        /// <summary>
        /// 删除职位分组
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("groups/{id}")]
        [HasPermission("Org.PositionGroup.Delete")]
        [ApiAccessLog(operateName: "删除职位分组", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeletePositionGroupAsync(Guid id)
        {
            await _positionService.DeletePositionGroupAsync(id);
        }

        #endregion
    }
}