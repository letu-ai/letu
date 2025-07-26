using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.DataDictionary
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