using FreeSql;
using System.Linq.Expressions;

namespace Letu.Repository
{
    public interface IRepository<T> : IBaseRepository<T> where T : class
    {
        /// <summary>
        /// 软删除，将<see cref="IDeletionProperty.IsDeleted"/>设置为true
        /// </summary>
        /// <param name="expression">条件表达式</param>
        /// <returns></returns>
        Task<int> SoftDeleteAsync(Expression<Func<T, bool>> expression);

        /// <summary>
        /// 查询单个实体
        /// </summary>
        /// <param name="expression">条件表达式</param>
        /// <returns></returns>
        Task<T> OneAsync(Expression<Func<T, bool>> expression);
    }
}