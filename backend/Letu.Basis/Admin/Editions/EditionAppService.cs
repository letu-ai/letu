using Letu.Basis.Admin.Editions.Dtos;
using Letu.Basis.Admin.Tenants;
using Letu.Core.Applications;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Editions
{
    public class EditionAppService : ApplicationService, IEditionAppService
    {
        private readonly IFreeSqlRepository<Edition> _editionRepository;

        // 添加租户仓储，用于计算TenantCount
        private readonly IFreeSqlRepository<Tenant> _tenantRepository;

        public EditionAppService(
            IFreeSqlRepository<Edition> editionRepository,
            IFreeSqlRepository<Tenant> tenantRepository)
        {
            _editionRepository = editionRepository;
            _tenantRepository = tenantRepository;
        }

        /// <summary>
        /// 新增版本
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        public async Task<bool> AddEditionAsync(EditionCreateOrUpdateInput dto)
        {
            var exist = await _editionRepository.Select.Where(x => x.Name == dto.Name).AnyAsync();
            if (exist)
                throw new BusinessException(message: "版本名称已存在");

            var edition = ObjectMapper.Map<EditionCreateOrUpdateInput, Edition>(dto);
            var result = await _editionRepository.InsertAsync(edition);

            return result != null;
        }

        /// <summary>
        /// 版本列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        public async Task<PagedResult<EditionListOutput>> GetEditionListAsync(EditionListInput dto)
        {
            var query = _editionRepository.Select;

            // 名称搜索
            if (!string.IsNullOrEmpty(dto.Name))
                query = query.Where(x => x.Name.Contains(dto.Name));

            // 排序
            query = query.OrderByDescending(x => x.CreationTime);

            // 分页
            var total = await query.CountAsync();
            var items = await query
                .Skip((dto.Current - 1) * dto.PageSize)
                .Take(dto.PageSize)
                .ToListAsync();

            // 转换为输出DTO
            var outputList = ObjectMapper.Map<List<Edition>, List<EditionListOutput>>(items);

            // 计算每个版本下的租户数量
            foreach (var output in outputList)
            {
                // 统计使用此版本的租户数量
                output.TenantCount = await _tenantRepository.Select
                    .Where(t => t.EditionId == output.Id)
                    .CountAsync();
            }

            var result = new PagedResult<EditionListOutput>(dto, total, outputList);

            return result;
        }

        /// <summary>
        /// 修改版本
        /// </summary>
        /// <param name="id">版本ID</param>
        /// <param name="input">版本信息</param>
        /// <returns></returns>
        public async Task<bool> UpdateEditionAsync(Guid id, EditionCreateOrUpdateInput input)
        {
            var edition = await _editionRepository.Select
                .Where(x => x.Id == id)
                .FirstAsync();

            if (edition == null)
                throw new BusinessException("版本不存在");

            var exist = await _editionRepository.Select
                .Where(x => x.Name == input.Name && x.Id != id)
                .AnyAsync();
            if (exist)
                throw new BusinessException("版本名称已存在");

            ObjectMapper.Map(input, edition);

            var result = await _editionRepository.UpdateAsync(edition);

            return result > 0;
        }

        /// <summary>
        /// 删除版本
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<bool> DeleteEditionAsync(Guid id)
        {
            var edition = await _editionRepository.Select
                .Where(x => x.Id == id)
                .FirstAsync();

            if (edition == null)
                throw new BusinessException("版本不存在");

            // 检查是否有租户使用此版本
            var hasTenants = await _tenantRepository.Select
                .Where(t => t.EditionId == id)
                .AnyAsync();
            if (hasTenants)
                throw new BusinessException("此版本下有租户，无法删除");

            var result = await _editionRepository.DeleteAsync(x => x.Id == id);

            return result > 0;
        }

        /// <summary>
        /// 获取版本下拉列表
        /// </summary>
        /// <returns>版本下拉列表数据</returns>
        public async Task<List<EditionInfoDto>> GetEditionSelectListAsync()
        {
            var editions = await _editionRepository.Select
                .OrderByDescending(x => x.CreationTime)
                .ToListAsync();

            return ObjectMapper.Map<List<Edition>, List<EditionInfoDto>>(editions);
        }
    }
}