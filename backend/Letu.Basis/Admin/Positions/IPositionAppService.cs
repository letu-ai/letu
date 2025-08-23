using Letu.Basis.Admin.Positions.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Positions
{
    public interface IPositionAppService
    {
        /// <summary>
        /// 新增职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddPositionAsync(PositionCreateOrUpdateInput dto);

        /// <summary>
        /// 职位分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<PositionListOutput>> GetPositionListAsync(PositionListInput dto);

        /// <summary>
        /// 修改职位
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdatePositionAsync(Guid id, PositionCreateOrUpdateInput dto);

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
        Task<List<TreeSelectOption>> GetPositionTreeOptionAsync();

        /// <summary>
        /// 新增职位分组
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddPositionGroupAsync(PositionGroupCreateOrUpdateInput dto);

        /// <summary>
        /// 职位分组分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<PositionGroupListOutput>> GetPositionGroupListAsync(PositionGroupListInput dto);

        /// <summary>
        /// 修改职位分组
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdatePositionGroupAsync(Guid id, PositionGroupCreateOrUpdateInput dto);

        /// <summary>
        /// 删除职位分组
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeletePositionGroupAsync(Guid id);
    }
}