using Letu.Basis.Admin.OrganizationUnits.Dtos;


namespace Letu.Basis.Admin.OrganizationUnits;
public interface IOrganizationUnitAppService
{
    /// <summary>
    /// 新增组织单元
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<bool> AddOrganizationUnitAsync(OrganizationUnitCreateOrUpdateInput input);

    /// <summary>
    /// 组织单元列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<List<OrganizationUnitListOutput>> GetOrganizationUnitListAsync(OrganizationUnitListInput input);

    /// <summary>
    /// 修改组织单元
    /// </summary>
    /// <param name="id"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<bool> UpdateOrganizationUnitAsync(Guid id, OrganizationUnitCreateOrUpdateInput input);

    /// <summary>
    /// 删除组织单元
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    Task<bool> DeleteOrganizationUnitAsync(Guid id);
}