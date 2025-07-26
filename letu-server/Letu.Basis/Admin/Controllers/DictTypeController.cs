﻿using Letu.Basis.Admin.DataDictionary;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Core.Attributes;
using Letu.Logger;
using Letu.Shared.Interfaces;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]/[action]")]
public class DictTypeController : ControllerBase
{
    private readonly IDataDictionaryAppService _dictTypeService;

    public DictTypeController(IDataDictionaryAppService dictTypeService)
    {
        _dictTypeService = dictTypeService;
    }

    /// <summary>
    /// 新增字典类型
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPost]
    [HasPermission("Sys.DictType.Add")]
    public async Task<AppResponse<bool>> AddDictTypeAsync([FromBody] DictTypeDto dto)
    {
        await _dictTypeService.AddDictTypeAsync(dto);
        return Result.Ok();
    }

    /// <summary>
    /// 分页查询字典类型列表
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpGet]
    [HasPermission("Sys.DictType.List")]
    public async Task<AppResponse<PagedResult<DictTypeResultDto>>> GetDictTypeListAsync([FromQuery] DictTypeSearchDto dto)
    {
        var data = await _dictTypeService.GetDictTypeListAsync(dto);
        return Result.Data(data);
    }

    /// <summary>
    /// 修改字典类型
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpPut]
    [HasPermission("Sys.DictType.Update")]
    public async Task<AppResponse<bool>> UpdateDictTypeAsync([FromBody] DictTypeDto dto)
    {
        await _dictTypeService.UpdateDictTypeAsync(dto);
        return Result.Ok();
    }

    /// <summary>
    /// 删除字典类型
    /// </summary>
    /// <param name="dictType"></param>
    /// <returns></returns>
    [HttpDelete("{dictType}")]
    [HasPermission("Sys.DictType.Delete")]
    [ApiAccessLog(operateName: "删除字典类型", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task<AppResponse<bool>> DeleteDictTypeAsync(string dictType)
    {
        await _dictTypeService.DeleteDictTypeAsync(dictType);
        return Result.Ok();
    }

    /// <summary>
    /// 字典选项
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<AppResponse<List<AppOption>>> GetDictDataOptionsAsync(string type)
    {
        var data = await _dictTypeService.GetDictDataOptionsAsync(type);
        return Result.Data(data);
    }

    /// <summary>
    /// 批量删除字典类型
    /// </summary>
    /// <param name="ids"></param>
    /// <returns></returns>
    [HttpDelete]
    [HasPermission("Sys.DictType.Delete")]
    [ApiAccessLog(operateName: "批量删除字典类型", operateType: [OperateType.Delete], reponseEnable: true)]
    public async Task<AppResponse<bool>> DeleteDictTypesAsync([FromBody] Guid[] ids)
    {
        await _dictTypeService.DeleteDictTypesAsync(ids);
        return Result.Ok();
    }
}