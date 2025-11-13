using Letu.Basis.Admin.DataDictionaries;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers;

[Authorize]
[ApiController]
[Route("api/data-dictionaries")]
public class DataDictionaryController : ControllerBase
{
    private readonly IDataDictionaryAppService dictAppService;

    public DataDictionaryController(IDataDictionaryAppService dictService)
    {
        dictAppService = dictService;
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
}
