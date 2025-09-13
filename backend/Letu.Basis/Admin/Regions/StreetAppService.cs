using Letu.Basis.Admin.Regions.Dtos;
using Letu.Repository;

namespace Letu.Basis.Admin.Regions;

public class StreetAppService : BasisAppService, IStreetAppService
{
    private readonly IFreeSqlRepository<Street> streetRepository;
    private readonly ILogger<StreetAppService> logger;

    public StreetAppService(
        IFreeSqlRepository<Street> streetRepository,
        ILogger<StreetAppService> logger)
    {
        this.streetRepository = streetRepository;
        this.logger = logger;
    }

    public async Task<List<StreetListOutput>> GetStreetsAsync(string regionCode)
    {
        return await streetRepository.Select
            .Where(x => x.RegionCode == regionCode)
            .OrderBy(x => x.Sort)
            .ToListAsync<StreetListOutput>();
    }

    public async Task<int> DeleteByRegionIdAsync(string regionCode)
    {
        logger.LogInformation("删除区域 {regionCode} 下的所有街道", regionCode);
        return await streetRepository.DeleteAsync(x => x.RegionCode == regionCode);
    }

    public async Task<List<Street>> BatchInsertAsync(List<Street> streets)
    {
        if (streets == null || streets.Count == 0)
            return new List<Street>();

        logger.LogInformation("批量插入 {count} 个街道", streets.Count);
        await streetRepository.InsertAsync(streets);
        return streets;
    }
}