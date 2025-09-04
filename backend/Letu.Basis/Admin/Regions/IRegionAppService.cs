using Letu.Basis.Admin.Regions.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Regions
{
    public interface IRegionAppService
    {
        /// <summary>
        /// 新增行政区域
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<RegionListOutput> AddRegionAsync(RegionCreateOrUpdateInput input);

        /// <summary>
        /// 修改行政区域
        /// </summary>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<RegionListOutput> UpdateRegionAsync(int id, RegionCreateOrUpdateInput input);

        /// <summary>
        /// 删除行政区域（级联删除子区域）
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task DeleteRegionAsync(int id);

        /// <summary>
        /// 根据父级代码获取子级区域
        /// </summary>
        /// <param name="parentId">父级区域代码，null表示从顶级开始</param>
        /// <returns></returns>
        Task<List<RegionListOutput>> GetChildrenAsync(int? parentId);

        /// <summary>
        /// 从高德地图API导入行政区域数据
        /// </summary>
        /// <returns></returns>
        Task<RegionImportResultDto> ImportFromAmapAsync();

        /// <summary>
        /// 获取导入进度
        /// </summary>
        /// <returns></returns>
        Task<RegionImportProgressDto> GetImportProgressAsync();

        /// <summary>
        /// 根据代码获取区域信息
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        Task<RegionListOutput?> GetRegionByCodeAsync(string code);
    }
}