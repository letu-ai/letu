using Letu.Admin.IService.System.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Admin.IService.System
{
    public interface IDictTypeService : IScopedDependency
    {
        Task AddDictTypeAsync(DictTypeDto dto);

        Task<PagedResult<DictTypeResultDto>> GetDictTypeListAsync(DictTypeSearchDto dto);

        Task UpdateDictTypeAsync(DictTypeDto dto);

        Task DeleteDictTypeAsync(string dictType);

        Task<List<AppOption>> GetDictDataOptionsAsync(string type);

        Task DeleteDictTypesAsync(Guid[] ids);
    }
}