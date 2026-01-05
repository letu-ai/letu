using Letu.Basis.Admin.UserTags;
using Letu.Basis.Admin.UserTags.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Letu.Shared.Consts;
using Letu.Shared.Generated;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.User.Default)]
[ApiController]
[Route("/api/admin/user-tags")]
public class UserTagController : ControllerBase
{
    private readonly IUserTagAppService _userTagService;

    public UserTagController(IUserTagAppService userTagService)
    {
        _userTagService = userTagService;
    }

    /// <summary>
    /// 获取所有用户标签列表（不分页）
    /// </summary>
    [HttpGet]
    public async Task<List<UserTagListOutput>> GetAllTagsAsync()
    {
        return await _userTagService.GetAllTagsAsync();
    }

    /// <summary>
    /// 创建用户标签
    /// </summary>
    [HttpPost]
    [Authorize(BasisPermissions.User.Create)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task<Guid> CreateTagAsync([FromBody] UserTagCreateInput input)
    {
        return await _userTagService.CreateTagAsync(input);
    }

    /// <summary>
    /// 更新用户标签
    /// </summary>
    [HttpPut("{id:Guid}")]
    [Authorize(BasisPermissions.User.Update)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task<bool> UpdateTagAsync(Guid id, [FromBody] UserTagUpdateInput input)
    {
        return await _userTagService.UpdateTagAsync(id, input);
    }

    /// <summary>
    /// 删除用户标签
    /// </summary>
    [HttpDelete("{id:Guid}")]
    [Authorize(BasisPermissions.User.Delete)]
    [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
    public async Task<bool> DeleteTagAsync(Guid id)
    {
        return await _userTagService.DeleteTagAsync(id);
    }

    /// <summary>
    /// 获取标签选项列表（用于下拉选择）
    /// </summary>
    [HttpGet("options")]
    public async Task<List<SelectOption>> GetTagSelectOptionsAsync()
    {
        return await _userTagService.GetTagSelectOptionsAsync();
    }
}