using Letu.Basis.Admin.UserTags.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.UserTags;

public interface IUserTagAppService
{
    /// <summary>
    /// 获取所有标签列表（不分页）
    /// </summary>
    Task<List<UserTagListOutput>> GetAllTagsAsync();

    /// <summary>
    /// 创建标签
    /// </summary>
    Task<Guid> CreateTagAsync(UserTagCreateInput input);

    /// <summary>
    /// 更新标签
    /// </summary>
    Task<bool> UpdateTagAsync(Guid id, UserTagUpdateInput input);

    /// <summary>
    /// 删除标签
    /// </summary>
    Task<bool> DeleteTagAsync(Guid id);

    /// <summary>
    /// 获取标签选项列表（用于下拉选择）
    /// </summary>
    Task<List<SelectOption>> GetTagSelectOptionsAsync();
}