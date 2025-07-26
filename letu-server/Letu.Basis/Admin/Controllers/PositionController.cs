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
    [Route("api/position")]
    public class PositionController : ControllerBase
    {
        private readonly IPositionAppService _positionService;

        public PositionController(IPositionAppService positionService)
        {
            _positionService = positionService;
        }

        /// <summary>
        /// 新增职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("add")]
        [HasPermission("Org.Position.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task<AppResponse<bool>> AddPositionAsync([FromBody] PositionDto dto)
        {
            await _positionService.AddPositionAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 职位分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("list")]
        [HasPermission("Org.Position.List")]
        public async Task<AppResponse<PagedResult<PositionListDto>>> GetPositionListAsync([FromQuery] PositionQueryDto dto)
        {
            var data = await _positionService.GetPositionListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 修改职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("update")]
        [HasPermission("Org.Position.Update")]
        public async Task<AppResponse<bool>> UpdatePositionAsync([FromBody] PositionDto dto)
        {
            await _positionService.UpdatePositionAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 删除职位
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("delete/{id:guid}")]
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
        [HttpGet("options")]
        public async Task<AppResponse<List<AppOptionTree>>> GetPositionTreeOptionAsync()
        {
            var data = await _positionService.GetPositionTreeOptionAsync();
            return Result.Data(data);
        }
    }
}