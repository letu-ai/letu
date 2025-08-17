using FreeSql;
using System.Linq.Expressions;
using Volo.Abp.Domain.Entities;

namespace Letu.Repository
{
    public class FreeSqlRepository<TEntity> : FreeSqlBasicRepositoryBase<TEntity>, IFreeSqlRepository<TEntity>
        where TEntity : class, IEntity
    {
        public FreeSqlRepository(UnitOfWorkManager uowManger) : base(uowManger.Orm)
        {
        }

        public Task<TEntity> OneAsync(Expression<Func<TEntity, bool>> expression)
        {
            return base.Select.Where(expression).ToOneAsync();
        }

        public Task<int> SoftDeleteAsync(Expression<Func<TEntity, bool>> expression)
        {
            return base.UpdateDiy.Where(expression).SetDto(new { IsDeleted = true }).ExecuteAffrowsAsync();
        }
    }

    public class FreeSqlRepository<TEntity, TKey> : FreeSqlBasicRepositoryBase<TEntity, TKey>, IFreeSqlRepository<TEntity, TKey>
        where TEntity : class, IEntity<TKey>
    {
        public FreeSqlRepository(UnitOfWorkManager uowManger) : base(uowManger.Orm)
        {
        }

        public int Delete(TKey id)
        {
            return base.Delete(e => e.Id!.Equals(id));
        }

        public Task<int> DeleteAsync(TKey id, CancellationToken cancellationToken = default)
        {
            return base.DeleteAsync(e => e.Id!.Equals(id), cancellationToken);
        }

        public TEntity Find(TKey id)
        {
            return base.Select.Where(e => e.Id!.Equals(id)).First();
        }

        public Task<TEntity> FindAsync(TKey id, CancellationToken cancellationToken = default)
        {
            return base.Select.Where(e => e.Id!.Equals(id)).FirstAsync(cancellationToken);
        }

        public TEntity Get(TKey id)
        {
            var entity = Find(id);
            if (entity == null)
            {
                throw new EntityNotFoundException(typeof(TEntity), id);
            }
            return entity;
        }

        public Task<TEntity> GetAsync(TKey id, CancellationToken cancellationToken = default)
        {
            return base.Select.Where(e => e.Id!.Equals(id)).ToOneAsync(cancellationToken);
        }

        public Task<TEntity> OneAsync(Expression<Func<TEntity, bool>> expression)
        {
            return base.Select.Where(expression).ToOneAsync();
        }
        public Task<int> SoftDeleteAsync(Expression<Func<TEntity, bool>> expression)
        {
            return base.UpdateDiy.Where(expression).SetDto(new { IsDeleted = true }).ExecuteAffrowsAsync();
        }
    }
}