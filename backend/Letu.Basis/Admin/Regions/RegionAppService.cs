using Letu.Basis.Admin.Regions.Dtos;
using Letu.Basis.Amaps;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Microsoft.Extensions.Caching.Memory;

namespace Letu.Basis.Admin.Regions;

public class RegionAppService : BasisAppService, IRegionAppService
{
    private readonly IFreeSqlRepository<Region> regionRepository;
    private readonly IFreeSqlRepository<Street> streetRepository;
    private readonly IAmapAppService amapAppService;
    private readonly IStreetAppService streetAppService;
    private readonly IMemoryCache memoryCache;
    private readonly ILogger<RegionAppService> logger;
    private const string ImportProgressKey = "region_import_progress";
    private const int ApiDelayMs = 400;

    public RegionAppService(
        IFreeSqlRepository<Region> regionRepository,
        IFreeSqlRepository<Street> streetRepository,
        IAmapAppService amapAppService,
        IStreetAppService streetAppService,
        IMemoryCache memoryCache,
        ILogger<RegionAppService> logger)
    {
        this.regionRepository = regionRepository;
        this.streetRepository = streetRepository;
        this.amapAppService = amapAppService;
        this.streetAppService = streetAppService;
        this.memoryCache = memoryCache;
        this.logger = logger;
    }

    public async Task<RegionListOutput> GetRegionByCodeAsync(string code)
    {
        return await regionRepository.Select
            .Where(x => x.Code == code)
            .ToOneAsync<RegionListOutput>()
            ?? throw HttpFriendlyException.NotFound($"没有找到{code}对应的行政区域");
    }

    public async Task<List<RegionListOutput>> GetChildrenByCodeAsync(string? parentCode)
    {
        // 获取顶级区域（省份）
        return await regionRepository.Select
            .Where(x => x.ParentCode == parentCode)
            .OrderBy(x => new { x.Code })
            .ToListAsync<RegionListOutput>();
    }

    public async Task<List<RegionListOutput>> GetPathByCodeAsync(string code)
    {
        var path = new List<RegionListOutput>();

        // 获取当前区域
        var current = await regionRepository.Select
            .Where(x => x.Code == code)
            .ToOneAsync<RegionListOutput>();

        if (current == null)
            return path;

        // 构建完整路径
        path.Add(current);

        // 向上追溯父级
        while (current?.ParentCode != null)
        {
            current = await regionRepository.Select
                .Where(x => x.Code == current.ParentCode)
                .ToOneAsync<RegionListOutput>();

            if (current != null)
                path.Insert(0, current);
        }

        return path;
    }

    public async Task<RegionImportResultDto> ImportFromAmapAsync(bool includeStreets)
    {
        logger.LogInformation("开始从高德地图导入行政区域数据，includeStreets: {includeStreets}", includeStreets);
        var result = new RegionImportResultDto();

        try
        {
            // 初始化进度
            UpdateImportProgress(0, "", 0, 0, true);

            // 清空现有数据
            await ClearExistingDataAsync();

            // 导入省份及其下级数据
            await ImportProvincesAsync(result, includeStreets);
            result.Success = true;

            logger.LogInformation("导入完成！总计: {total} 条，省份: {provinces} 个，市: {cities} 个，区县: {districts} 个，街道: {streets} 个",
                result.TotalCount, result.ProvincesCount, result.CitiesCount, result.DistrictsCount, result.StreetsCount);

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

    private async Task ClearExistingDataAsync()
    {
        logger.LogInformation("清空现有行政区域数据和街道数据");
        var streetDeleteCount = await streetRepository.DeleteAsync(x => true);
        var regionDeleteCount = await regionRepository.DeleteAsync(x => true);
        logger.LogInformation("已删除 {regionCount} 条行政区域数据，{streetCount} 条街道数据",
            regionDeleteCount, streetDeleteCount);
    }

    private async Task ImportProvincesAsync(RegionImportResultDto result, bool includeStreets)
    {
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

            var provinceEntity = CreateRegionEntity(
                code: province.AdCode,
                parentCode: null,
                name: province.Name,
                center: province.Center,
                level: RegionLevel.Province,
                sort: currentProvinceIndex,
                path: province.AdCode,
                nextLevel: RegionLevel.City
            );

            provinceEntity = await regionRepository.InsertAsync(provinceEntity);
            result.TotalCount++;
            result.ProvincesCount++;
            logger.LogDebug("已插入省份实体: {name}, ID: {id}", province.Name, provinceEntity.Id);

            // 导入该省的城市数据
            await ImportCitiesAsync(provinceEntity, province, result, includeStreets);

            await Task.Delay(ApiDelayMs);
        }
    }

    private async Task ImportCitiesAsync(Region provinceEntity, dynamic provinceData, RegionImportResultDto result, bool includeStreets)
    {
        logger.LogDebug("获取省份 {province} 的市级数据", provinceEntity.Name);
        var cities = await amapAppService.GetDistrictAsync(provinceEntity.Code);

        if (cities.Length > 0 && cities[0].Districts != null)
        {
            logger.LogDebug("省份 {province} 有 {count} 个市", provinceEntity.Name, cities[0].Districts.Length);
            var cityIndex = 0;

            foreach (var city in cities[0].Districts)
            {
                cityIndex++;
                logger.LogDebug("处理市: {city} (AdCode: {adCode})", city.Name, city.AdCode);

                // 获取该市的下级数据，用于判断下级类型
                var subDistricts = await amapAppService.GetDistrictAsync(city.AdCode);
                var nextLevel = DetermineNextLevel(subDistricts);

                var cityEntity = CreateRegionEntity(
                    code: city.AdCode,
                    parentCode: provinceEntity.Code,
                    name: city.Name,
                    center: city.Center,
                    level: RegionLevel.City,
                    sort: cityIndex,
                    path: $"{provinceEntity.Code}/{city.AdCode}",
                    nextLevel: nextLevel
                );

                cityEntity = await regionRepository.InsertAsync(cityEntity);
                result.TotalCount++;
                result.CitiesCount++;

                // 处理市级下的数据
                if (subDistricts.Length > 0 && subDistricts[0].Districts != null)
                {
                    await ImportDistrictsAsync(cityEntity, subDistricts[0].Districts!, result, includeStreets);
                }

                await Task.Delay(ApiDelayMs);
            }

            // 更新省级的NextLevel
            var cityCount = cities[0].Districts!.Length;
            if (cityCount > 0)
            {
                provinceEntity.NextLevel = RegionLevel.City;
                await regionRepository.UpdateAsync(provinceEntity);
            }
        }
    }

    private async Task ImportDistrictsAsync(Region cityEntity, dynamic[] districts, RegionImportResultDto result, bool includeStreets)
    {
        var streets = new List<Street>();
        var districtEntities = new List<Region>();
        var itemIndex = 0;

        foreach (var item in districts)
        {
            itemIndex++;

            if (item.Level == "district") // 是区县
            {
                var districtEntity = CreateRegionEntity(
                    code: item.AdCode,
                    parentCode: cityEntity.Code,
                    name: item.Name,
                    center: item.Center,
                    level: RegionLevel.County,
                    sort: itemIndex,
                    path: $"{cityEntity.Path}/{item.AdCode}",
                    nextLevel: includeStreets ? RegionLevel.Street : RegionLevel.None
                );

                districtEntities.Add(districtEntity);
                result.TotalCount++;
                result.DistrictsCount++;
            }
            else if (item.Level == "street" && includeStreets) // 直接是街道（无区县的市）
            {
                var streetEntity = new Street
                {
                    RegionCode = item.AdCode,
                    Name = item.Name,
                    Center = item.Center,
                    Sort = itemIndex,
                };
                streets.Add(streetEntity);
                result.TotalCount++;
            }
        }

        // 批量插入区县
        if (districtEntities.Count > 0)
        {
            await regionRepository.InsertAsync(districtEntities);

            // 处理每个区县下的街道（如果需要导入街道）
            if (includeStreets)
            {
                foreach (var districtEntity in districtEntities)
                {
                    var districtStreets = await ImportStreetsAsync(districtEntity.Code, districtEntity);
                    streets.AddRange(districtStreets);

                    await Task.Delay(ApiDelayMs);
                }
            }
        }

        // 批量插入所有街道（如果需要导入街道）
        if (includeStreets && streets.Count > 0)
        {
            await streetAppService.BatchInsertAsync(streets);
            result.StreetsCount += streets.Count;
        }

        // 更新市级的NextLevel
        var totalChildren = cityEntity.NextLevel == RegionLevel.City ? districtEntities.Count
                          : cityEntity.NextLevel == RegionLevel.Street ? streets.Count
                          : 0;

        if (totalChildren > 0)
        {
            cityEntity.NextLevel = districtEntities.Count > 0 ? RegionLevel.City : RegionLevel.Street;
            await regionRepository.UpdateAsync(cityEntity);
        }
    }

    private async Task<List<Street>> ImportStreetsAsync(string regionCode, Region regionEntity)
    {
        var streets = new List<Street>();
        var districtStreets = await amapAppService.GetDistrictAsync(regionCode);

        if (districtStreets.Length > 0 && districtStreets[0].Districts != null)
        {
            var streetIndex = 0;
            foreach (var streetItem in districtStreets[0].Districts)
            {
                streetIndex++;
                var streetEntity = new Street
                {
                    RegionCode = streetItem.AdCode,
                    Name = streetItem.Name,
                    Center = streetItem.Center,
                    Sort = streetIndex,
                };
                streets.Add(streetEntity);
            }

            // 更新区县如果没有街道则NextLevel设为0（叶节点）
            var streetCount = districtStreets[0]?.Districts?.Length ?? 0;
            if (streetCount == 0)
            {
                regionEntity.NextLevel = RegionLevel.None;
                await regionRepository.UpdateAsync(regionEntity);
            }
        }

        return streets;
    }

    private static Region CreateRegionEntity(string code, string? parentCode, string name, string center, RegionLevel level,
        int sort, string path, RegionLevel nextLevel)
    {
        return new Region
        {
            Code = code,
            ParentCode = parentCode,
            Name = name,
            Center = center,
            Level = level,
            Sort = sort,
            Path = path,
            NextLevel = nextLevel
        };
    }

    private RegionLevel DetermineNextLevel(AmapDistrict[]? subDistricts)
    {
        if (subDistricts?.Length > 0 && subDistricts[0].Districts != null && subDistricts[0]?.Districts?.Length > 0)
        {
            var firstChild = subDistricts[0]?.Districts?.FirstOrDefault();
            if (firstChild?.Level == "district")
            {
                return RegionLevel.City;
            }
            else if (firstChild?.Level == "street")
            {
                return RegionLevel.Street;
            }
        }
        return RegionLevel.None;
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
}