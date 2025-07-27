using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Positions.Dtos;
using Letu.Core.Attributes;
using Letu.Logger;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Admin.Controllers
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
        public async Task<AppResponse<bool>> CreatePositionAsync([FromBody] PositionDto dto)
        {
            await _positionService.AddPositionAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 职位分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Org.Position.List")]
        public async Task<AppResponse<PagedResult<PositionListDto>>> GetPositionsAsync([FromQuery] PositionQueryDto dto)
        {
            var data = await _positionService.GetPositionListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 修改职位
        /// </summary>
        /// <param name="id">职位ID</param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [HasPermission("Org.Position.Update")]
        public async Task<AppResponse<bool>> UpdatePositionAsync(Guid id, [FromBody] PositionDto dto)
        {
            if (id != dto.Id)
            {
                return Result.Fail("提供的ID与职位对象ID不匹配");
            }

            await _positionService.UpdatePositionAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 删除职位
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [HasPermission("Org.Position.Delete")]
        [ApiAccessLog(operateName: "删除职位", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task<AppResponse<bool>> DeletePositionAsync(Guid id)
        {
            await _positionService.DeletePositionAsync(id);
            return Result.Ok();
        }

        /// <summary>
        /// 职位分组+职位树
        /// </summary>
        /// <returns></returns>
        [HttpGet("tree")]
        public async Task<AppResponse<List<AppOptionTree>>> GetPositionTreeAsync()
        {
            var data = await _positionService.GetPositionTreeOptionAsync();
            return Result.Data(data);
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
        public async Task<AppResponse<bool>> CreatePositionGroupAsync([FromBody] PositionGroupDto dto)
        {
            await _positionService.AddPositionGroupAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 职位分组分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("groups")]
        [HasPermission("Org.PositionGroup.List")]
        public async Task<AppResponse<List<PositionGroupListDto>>> GetPositionGroupsAsync([FromQuery] PositionGroupQueryDto dto)
        {
            var data = await _positionService.GetPositionGroupListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 修改职位分组
        /// </summary>
        /// <param name="id">职位分组ID</param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("groups/{id}")]
        [HasPermission("Org.PositionGroup.Update")]
        public async Task<AppResponse<bool>> UpdatePositionGroupAsync(Guid id, [FromBody] PositionGroupDto dto)
        {
            if (id != dto.Id)
            {
                return Result.Fail("提供的ID与职位分组对象ID不匹配");
            }

            await _positionService.UpdatePositionGroupAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 删除职位分组
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("groups/{id}")]
        [HasPermission("Org.PositionGroup.Delete")]
        [ApiAccessLog(operateName: "删除职位分组", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task<AppResponse<bool>> DeletePositionGroupAsync(Guid id)
        {
            await _positionService.DeletePositionGroupAsync(id);
            return Result.Ok();
        }

        #endregion
    }
}
