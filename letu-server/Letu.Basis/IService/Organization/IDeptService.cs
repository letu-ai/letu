using Letu.Basis.IService.Organization.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.IService.Organization
{
    public interface IDeptService : IScopedDependency
    {
        /// <summary>
        /// 新增部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddDeptAsync(DeptDto dto);

        /// <summary>
        /// 部门树形列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<List<DeptListDto>> GetDeptListAsync(DeptQueryDto dto);

        /// <summary>
        /// 修改部门
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateDeptAsync(DeptDto dto);

        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteDeptAsync(Guid id);
    }
}