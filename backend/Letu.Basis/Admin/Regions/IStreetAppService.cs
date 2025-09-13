using Letu.Basis.Admin.Regions.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Regions;

public interface IStreetAppService : IApplicationService
{
    /// <summary>
    /// 根据区域ID获取街道列表
    /// </summary>
    /// <param name="regionCode">区域ID</param>
    /// <returns>街道列表</returns>
    Task<List<StreetListOutput>> GetByRegionIdAsync(string regionCode);

    /// <summary>
    /// 根据区域ID删除街道
    /// </summary>
    /// <param name="regionCode">区域ID</param>
    /// <returns>删除的数量</returns>
    Task<int> DeleteByRegionIdAsync(string regionCode);

    /// <summary>
    /// 批量插入街道
    /// </summary>
    /// <param name="streets">街道列表</param>
    /// <returns>插入成功的街道列表</returns>
    Task<List<Street>> BatchInsertAsync(List<Street> streets);
}