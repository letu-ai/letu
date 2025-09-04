using Letu.Basis.Admin.DataDictionaries;
using Letu.Basis.Admin.DataDictionaries.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Logging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.DataDictionary.Default)]
    [ApiController]
    [Route("api/admin/data-dictionaries")]
    public class DataDictionaryController : ControllerBase
    {
        private readonly IDataDictionaryAppService dictAppService;

        public DataDictionaryController(IDataDictionaryAppService dictService)
        {
            dictAppService = dictService;
        }


        /// <summary>
        /// 新增字典
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.DataDictionary.Create)]
        public async Task AddDictionaryAsync([FromBody] DictionaryCreateInput input)
        {
            await dictAppService.AddDictionaryAsync(input);
        }

        /// <summary>
        /// 分页查询字典列表
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<PagedResult<DictionaryListOutput>> GetDictionaryListAsync([FromQuery] DictionaryListInput input)
        {
            return await dictAppService.GetDictionaryListAsync(input);
        }

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="input"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task UpdateDictionaryAsync(Guid id, [FromBody] DictionaryUpdateInput input)
        {
            await dictAppService.UpdateDictionaryAsync(id, input);
        }

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [Authorize(BasisPermissions.DataDictionary.Delete)]
        [ApiAccessLog(operateName: "删除字典", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteDictionaryAsync(Guid id)
        {
            await dictAppService.DeleteDictionaryAsync(id);
        }

        /// <summary>
        /// 批量删除字典
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpDelete]
        [Authorize(BasisPermissions.DataDictionary.Delete)]
        [ApiAccessLog(operateName: "批量删除字典", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteDictionariesAsync([FromBody] Guid[] ids)
        {
            await dictAppService.DeleteDictionariesAsync(ids);
        }

        /// <summary>
        /// 批量获取字典选项
        /// </summary>
        /// <param name="dictNames"></param>
        /// <returns></returns>
        [HttpGet("options")]
        public async Task<Dictionary<string, List<SelectOption>?>> GetDictionaryOptionsBatchAsync([FromQuery] string[] dictNames)
        {
            return await dictAppService.GetDictionaryOptionsBatchAsync(dictNames);
        }

        /// <summary>
        /// 字典选项
        /// </summary>
        /// <param name="dictName"></param>
        /// <returns></returns>
        [HttpGet("{dictName}/options")]
        public async Task<List<SelectOption>> GetDictDataOptionsAsync(string dictName)
        {
            return await dictAppService.GetDictionaryOptionsAsync(dictName);
        }

        /// <summary>
        /// 新增字典项
        /// </summary>
        /// <param name="dictName"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPost("{dictName}/items")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task AddItemAsync(string dictName, ItemCreateOrUpdateInput input)
        {
            await dictAppService.AddItemAsync(dictName, input);
        }

        /// <summary>
        /// 字典分页列表
        /// </summary>
        /// <param name="dictName"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpGet("{dictName}/items")]
        public async Task<PagedResult<ItemListOutput>> GetItemListAsync(string dictName, [FromQuery] ItemListInput input)
        {
            return await dictAppService.GetItemListAsync(dictName, input);
        }

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="dictName"></param>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPut("{dictName}/items/{id}")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        public async Task UpdateItemAsync(string dictName, Guid id, ItemCreateOrUpdateInput input)
        {
            await dictAppService.UpdateItemAsync(dictName, id, input);
        }

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="dictName"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpDelete("{dictName}/items")]
        [Authorize(BasisPermissions.DataDictionary.Update)]
        [ApiAccessLog(operateName: "删除字典数据", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteItemAsync(string dictName, [FromBody] Guid[] ids)
        {
            await dictAppService.DeleteItemAsync(dictName, ids);
        }
    }
}