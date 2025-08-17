using Letu.Applications;
using Letu.Basis.Admin.DataDictionary;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Basis.Permissions;

using Letu.Logging;
using Letu.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.DataDictionary.Default)]
    [ApiController]
    [Route("api/admin/data-dictionaries")]
    public class DataDictionaryController : ControllerBase
    {
        private readonly IDataDictionaryAppService _dictService;
        private readonly IDataDictionaryAppService _dictTypeService;

        public DataDictionaryController(IDataDictionaryAppService dictService, IDataDictionaryAppService dictTypeService)
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
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task AddDictDataAsync(ItemCreateOrUpdateInput dto)
        {
            await _dictService.AddDictDataAsync(dto);
        }

        /// <summary>
        /// 字典分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<PagedResult<ItemListOutput>> GetDictDataListAsync([FromQuery] ItemListInput dto)
        {
            return await _dictService.GetDataItemListAsync(dto);
        }

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task UpdateDictDataAsync(Guid id, ItemCreateOrUpdateInput dto)
        {
            await _dictService.UpdateDictDataAsync(id, dto);
        }

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpDelete]
        [Authorize(BasisPermissions.DataDictionary.Update)]
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
        [Authorize(BasisPermissions.DataDictionary.Create)]
        public async Task AddDictTypeAsync([FromBody] TypeCreateOrUpdateInput dto)
        {
            await _dictTypeService.AddDictTypeAsync(dto);
        }

        /// <summary>
        /// 分页查询字典类型列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("types")]
        public async Task<PagedResult<TypeListOutput>> GetDictTypeListAsync([FromQuery] TypeListInput dto)
        {
            return await _dictTypeService.GetDictTypeListAsync(dto);
        }

        /// <summary>
        /// 修改字典类型
        /// </summary>
        /// <param name="dto"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpPut("types/{id}")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task UpdateDictTypeAsync(Guid id, [FromBody] TypeCreateOrUpdateInput dto)
        {
            await _dictTypeService.UpdateDictTypeAsync(id, dto);
        }

        /// <summary>
        /// 删除字典类型
        /// </summary>
        /// <param name="dictType"></param>
        /// <returns></returns>
        [HttpDelete("types/{dictType}")]
        [Authorize(BasisPermissions.DataDictionary.Delete)]
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
        [Authorize(BasisPermissions.DataDictionary.Delete)]
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