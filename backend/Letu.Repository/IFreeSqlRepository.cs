using FreeSql;
using System.Linq.Expressions;
using Volo.Abp.Domain.Entities;

namespace Letu.Repository;

public interface IFreeSqlRepository<TEntity> : IBaseRepository<TEntity> where TEntity : class, IEntity
{
    /// <summary>
    /// 软删除，将<see cref="ISoftDelete.IsDeleted"/>设置为true
    /// </summary>
    /// <param name="expression">条件表达式</param>
    /// <returns></returns>
    Task<int> SoftDeleteAsync(Expression<Func<TEntity, bool>> expression);

    /// <summary>
    /// 查询单个实体
    /// </summary>
    /// <param name="expression">条件表达式</param>
    /// <returns></returns>
    Task<TEntity> OneAsync(Expression<Func<TEntity, bool>> expression);
}


public interface IFreeSqlRepository<TEntity, TKey> : IBaseRepository<TEntity, TKey> where TEntity : class, IEntity<TKey>
{
    /// <summary>
    /// 软删除，将<see cref="ISoftDelete.IsDeleted"/>设置为true
    /// </summary>
    /// <param name="expression">条件表达式</param>
    /// <returns></returns>
    Task<int> SoftDeleteAsync(Expression<Func<TEntity, bool>> expression);

    /// <summary>
    /// 查询单个实体
    /// </summary>
    /// <param name="expression">条件表达式</param>
    /// <returns></returns>
    Task<TEntity> OneAsync(Expression<Func<TEntity, bool>> expression);
}