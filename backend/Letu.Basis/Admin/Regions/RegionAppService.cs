using Letu.Basis.Admin.Regions.Dtos;
using Letu.Basis.Amaps;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Microsoft.Extensions.Caching.Memory;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.Regions;

public class RegionAppService : BasisAppService, IRegionAppService
{
    private readonly IFreeSqlRepository<Region> regionRepository;
    private readonly IAmapAppService amapAppService;
    private readonly IMemoryCache memoryCache;
    private readonly ILogger<RegionAppService> logger;
    private const string ImportProgressKey = "region_import_progress";

    public RegionAppService(
        IFreeSqlRepository<Region> regionRepository,
        IAmapAppService amapAppService,
        IMemoryCache memoryCache,
        ILogger<RegionAppService> logger)
    {
        this.regionRepository = regionRepository;
        this.amapAppService = amapAppService;
        this.memoryCache = memoryCache;
        this.logger = logger;
    }

    public async Task<RegionListOutput> AddRegionAsync(RegionCreateOrUpdateInput input)
    {
        // 验证区域代码格式和唯一性
        if (await regionRepository.Select.AnyAsync(x => x.Code == input.Code))
        {
            throw HttpFriendlyException.BadRequest($"区域代码{input.Code}已存在");
        }

        // 根据父级ID计算level
        int level;
        if (input.ParentId.HasValue)
        {
            var parent = await regionRepository.Where(x => x.Id == input.ParentId.Value).FirstAsync();
            if (parent == null)
            {
                throw HttpFriendlyException.BadRequest("父级区域不存在");
            }
            level = parent.Level + 1;

            // 验证层级不超过4级
            if (level > 4)
            {
                throw HttpFriendlyException.BadRequest("超过最大层级限制（4级）");
            }
        }
        else
        {
            // 没有父级，默认为省级（1级）
            level = 1;
        }

        var entity = ObjectMapper.Map<RegionCreateOrUpdateInput, Region>(input);
        entity.Level = level; // 设置计算好的level
        entity = await regionRepository.InsertAsync(entity);
        return ObjectMapper.Map<Region, RegionListOutput>(entity);
    }

    public async Task DeleteRegionAsync(int id)
    {
        var code = await regionRepository.Select
            .Where(x => x.Id == id)
            .ToOneAsync(x => x.Code);

        // 级联删除：删除所有以当前代码为前缀的区域
        if (code != null)
            await regionRepository.DeleteAsync(x => x.Code.StartsWith(code));
    }

    public async Task<List<RegionListOutput>> GetChildrenAsync(int? parentId)
    {
        return await regionRepository.Select
            .Where(x => x.ParentId == parentId)
            .OrderBy(x => new { x.Code })
            .ToListAsync<RegionListOutput>();
    }

    public async Task<RegionListOutput?> GetRegionByCodeAsync(string code)
    {
        return await regionRepository.Select
            .Where(x => x.Code == code)
            .ToOneAsync<RegionListOutput>();
    }

    public async Task<RegionImportResultDto> ImportFromAmapAsync()
    {
        logger.LogInformation("开始从高德地图导入行政区域数据");
        var result = new RegionImportResultDto();
        var allRegions = new List<Region>();

        try
        {
            // 初始化进度
            UpdateImportProgress(0, "", 0, 0, true);

            // 清空现有数据
            logger.LogInformation("清空现有行政区域数据");
            var deleteCount = await regionRepository.DeleteAsync(x => true);
            logger.LogInformation("已删除 {count} 条现有数据", deleteCount);

            // 获取所有省份
            logger.LogInformation("开始从高德API获取省份数据");
            var provinces = await amapAppService.GetAllProvincesAsync();
            var totalProvinces = provinces.Length;
            logger.LogInformation("获取到 {count} 个省份", totalProvinces);
            var currentProvinceIndex = 0;

            foreach (var province in provinces)
            {
                currentProvinceIndex++;
                logger.LogInformation("正在处理省份 {index}/{total}: {name} (AdCode: {adCode})",
                    currentProvinceIndex, totalProvinces, province.Name, province.AdCode);

                UpdateImportProgress(
                    percentage: (currentProvinceIndex * 100) / totalProvinces,
                    currentProvince: province.Name,
                    current: currentProvinceIndex,
                    total: totalProvinces,
                    isImporting: true
                );

                // 创建并插入省份实体
                var provinceEntity = new Region
                {
                    Code = province.AdCode,
                    Name = province.Name,
                    Center = province.Center,
                    Level = 1, // 省级
                    Sort = currentProvinceIndex,
                    IsEnabled = true,
                    ParentId = null
                };
                provinceEntity = await regionRepository.InsertAsync(provinceEntity);
                allRegions.Add(provinceEntity);
                result.ProvincesCount++;
                logger.LogDebug("已插入省份实体: {name}, ID: {id}", province.Name, provinceEntity.Id);

                // 获取该省的所有市
                logger.LogDebug("获取省份 {province} 的市级数据", province.Name);
                var cities = await amapAppService.GetDistrictAsync(province.AdCode);
                if (cities.Length > 0 && cities[0].Districts != null)
                {
                    logger.LogDebug("省份 {province} 有 {count} 个市", province.Name, cities[0].Districts.Length);
                    var cityIndex = 0;
                    foreach (var city in cities[0].Districts)
                    {
                        cityIndex++;
                        logger.LogDebug("处理市: {city} (AdCode: {adCode})", city.Name, city.AdCode);
                        // 创建并插入市级实体
                        var cityEntity = new Region
                        {
                            Code = city.AdCode,
                            Name = city.Name,
                            Center = city.Center,
                            Level = 2, // 市级
                            Sort = cityIndex,
                            IsEnabled = true,
                            ParentId = provinceEntity.Id
                        };
                        cityEntity = await regionRepository.InsertAsync(cityEntity);
                        allRegions.Add(cityEntity);
                        result.CitiesCount++;

                        // 获取该市的所有区县
                        var districts = await amapAppService.GetDistrictAsync(city.AdCode);
                        if (districts.Length > 0 && districts[0].Districts != null)
                        {
                            var districtIndex = 0;
                            var districtEntities = new List<Region>();
                            foreach (var district in districts[0].Districts)
                            {
                                districtIndex++;
                                // 创建区县实体（先收集，最后批量插入）
                                var districtEntity = new Region
                                {
                                    Code = district.AdCode,
                                    Name = district.Name,
                                    Center = district.Center,
                                    Level = 3, // 区县级
                                    Sort = districtIndex,
                                    IsEnabled = true,
                                    ParentId = cityEntity.Id
                                };
                                districtEntities.Add(districtEntity);
                                result.DistrictsCount++;
                            }

                            // 批量插入该市的所有区县
                            if (districtEntities.Count > 0)
                            {
                                await regionRepository.InsertAsync(districtEntities);
                                allRegions.AddRange(districtEntities);
                            }
                        }

                        // 添加延迟避免API限流 (确保每秒不超过3次调用)
                        await Task.Delay(400);
                    }
                }

                // 添加延迟避免API限流 (确保每秒不超过3次调用)
                await Task.Delay(400);
            }

            result.TotalCount = allRegions.Count;
            result.Success = true;

            logger.LogInformation("导入完成！总计: {total} 条，省份: {provinces} 个，市: {cities} 个，区县: {districts} 个",
                result.TotalCount, result.ProvincesCount, result.CitiesCount, result.DistrictsCount);

            // 清除进度缓存
            memoryCache.Remove(ImportProgressKey);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "导入行政区域数据失败");
            result.Success = false;
            result.ErrorMessage = ex.Message;
            memoryCache.Remove(ImportProgressKey);
            throw;
        }

        return result;
    }

    public async Task<RegionImportProgressDto> GetImportProgressAsync()
    {
        return await Task.FromResult(
            memoryCache.Get<RegionImportProgressDto>(ImportProgressKey)
            ?? new RegionImportProgressDto { IsImporting = false }
        );
    }

    private void UpdateImportProgress(int percentage, string currentProvince, int current, int total, bool isImporting)
    {
        var progress = new RegionImportProgressDto
        {
            Percentage = percentage,
            CurrentProvince = currentProvince,
            Current = current,
            Total = total,
            IsImporting = isImporting
        };

        memoryCache.Set(ImportProgressKey, progress, TimeSpan.FromMinutes(10));
    }

    public async Task<RegionListOutput> UpdateRegionAsync(int id, RegionCreateOrUpdateInput input)
    {
        var entity = await regionRepository.Where(x => x.Id == id).FirstAsync();
        if (entity == null)
        {
            throw new EntityNotFoundException(typeof(Region), id);
        }

        // 如果代码发生变更，验证新代码
        if (entity.Code != input.Code)
        {
            if (await regionRepository.Select.AnyAsync(x => x.Code == input.Code && x.Id != id))
            {
                throw HttpFriendlyException.BadRequest($"区域代码{input.Code}已存在");
            }
        }

        // 重新计算level
        int level;
        if (input.ParentId.HasValue)
        {
            var parent = await regionRepository.Where(x => x.Id == input.ParentId.Value).FirstAsync();
            if (parent == null)
            {
                throw HttpFriendlyException.BadRequest("父级区域不存在");
            }
            level = parent.Level + 1;

            // 验证层级不超过4级
            if (level > 4)
            {
                throw HttpFriendlyException.BadRequest("超过最大层级限制（4级）");
            }
        }
        else
        {
            // 没有父级，默认为省级（1级）
            level = 1;
        }

        ObjectMapper.Map(input, entity);
        entity.Level = level; // 设置重新计算的level
        await regionRepository.UpdateAsync(entity);
        return ObjectMapper.Map<Region, RegionListOutput>(entity);
    }
}