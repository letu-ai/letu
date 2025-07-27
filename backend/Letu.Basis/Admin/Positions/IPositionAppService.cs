using Letu.Basis.Admin.Positions.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Positions
{
    public interface IPositionAppService : IScopedDependency
    {
        /// <summary>
        /// 新增职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddPositionAsync(PositionDto dto);

        /// <summary>
        /// 职位分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<PositionListDto>> GetPositionListAsync(PositionQueryDto dto);

        /// <summary>
        /// 修改职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdatePositionAsync(PositionDto dto);

        /// <summary>
        /// 删除职位
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeletePositionAsync(Guid id);

        /// <summary>
        /// 职位分组+职位树
        /// </summary>
        /// <returns></returns>
        Task<List<AppOptionTree>> GetPositionTreeOptionAsync();

        /// <summary>
        /// 新增职位分组
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddPositionGroupAsync(PositionGroupDto dto);

        /// <summary>
        /// 职位分组分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<PositionGroupListDto>> GetPositionGroupListAsync(PositionGroupQueryDto dto);

        /// <summary>
        /// 修改职位分组
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdatePositionGroupAsync(PositionGroupDto dto);

        /// <summary>
        /// 删除职位分组
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeletePositionGroupAsync(Guid id);
    }
}