using Letu.Applications;
using Letu.Basis.Admin.DataDictionary;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Core.Attributes;
using Letu.Logging;
using Letu.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/data-dictionaries")]
    public class DictDataController : ControllerBase
    {
        private readonly IDataDictionaryAppService _dictService;
        private readonly IDataDictionaryAppService _dictTypeService;

        public DictDataController(IDataDictionaryAppService dictService, IDataDictionaryAppService dictTypeService)
        {
            _dictService = dictService;
            _dictTypeService = dictTypeService;
        }

        /// <summary>
        /// 新增字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [HasPermission("Sys.DictData.Add")]
        public async Task AddDictDataAsync(DictDataDto dto)
        {
            await _dictService.AddDictDataAsync(dto);
        }

        /// <summary>
        /// 字典分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Sys.DictData.List")]
        public async Task<PagedResult<DictDataListDto>> GetDictDataListAsync([FromQuery] DictDataQueryDto dto)
        {
            return await _dictService.GetDictDataListAsync(dto);
        }

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut]
        [HasPermission("Sys.DictData.Update")]
        public async Task UpdateDictDataAsync(DictDataDto dto)
        {
            await _dictService.UpdateDictDataAsync(dto);
        }

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpDelete]
        [HasPermission("Sys.DictData.Delete")]
        [ApiAccessLog(operateName: "删除字典数据", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteDictDataAsync([FromBody] Guid[] ids)
        {
            await _dictService.DeleteDictDataAsync(ids);
        }

        
    /// <summary>
    /// 新增字典类型
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPost("types")]
    [HasPermission("Sys.DictType.Add")]
    public async Task AddDictTypeAsync([FromBody] DictTypeDto dto)
    {
        await _dictTypeService.AddDictTypeAsync(dto);
    }

    /// <summary>
    /// 分页查询字典类型列表
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpGet("types")]
    [HasPermission("Sys.DictType.List")]
    public async Task<PagedResult<DictTypeResultDto>> GetDictTypeListAsync([FromQuery] DictTypeSearchDto dto)
    {
        return await _dictTypeService.GetDictTypeListAsync(dto);
    }

    /// <summary>
    /// 修改字典类型
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPut("types")]
    [HasPermission("Sys.DictType.Update")]
    public async Task UpdateDictTypeAsync([FromBody] DictTypeDto dto)
    {
        await _dictTypeService.UpdateDictTypeAsync(dto);
    }

    /// <summary>
    /// 删除字典类型
    /// </summary>
    /// <param name="dictType"></param>
    /// <returns></returns>
    [HttpDelete("types/{dictType}")]
    [HasPermission("Sys.DictType.Delete")]
    [ApiAccessLog(operateName: "删除字典类型", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task DeleteDictTypeAsync(string dictType)
    {
        await _dictTypeService.DeleteDictTypeAsync(dictType);
    }


    /// <summary>
    /// 批量删除字典类型
    /// </summary>
    /// <param name="ids"></param>
    /// <returns></returns>
    [HttpDelete("types")]
    [HasPermission("Sys.DictType.Delete")]
    [ApiAccessLog(operateName: "批量删除字典类型", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task DeleteDictTypesAsync([FromBody] Guid[] ids)
    {
        await _dictTypeService.DeleteDictTypesAsync(ids);
    }
    
    /// <summary>
    /// 字典选项
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    [HttpGet("types/type-options")]
    public async Task<List<AppOption>> GetDictDataOptionsAsync(string type)
    {
        return await _dictTypeService.GetDictDataOptionsAsync(type);
    }

    }
}