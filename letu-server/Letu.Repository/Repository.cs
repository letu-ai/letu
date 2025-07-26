using FreeSql;
using System.Linq.Expressions;

namespace Letu.Repository
{
    internal class Repository<T> : BaseRepository<T>, IRepository<T>
        where T : class
    {
        public Repository(UnitOfWorkManager unitOfWorkManager) : base(unitOfWorkManager.Orm)
        {
            unitOfWorkManager?.Binding(this);
        }

        public Task<T> OneAsync(Expression<Func<T, bool>> expression)
        {
            return base.Select.Where(expression).ToOneAsync();
        }

        public Task<int> SoftDeleteAsync(Expression<Func<T, bool>> expression)
        {
            return base.UpdateDiy.Where(expression).SetDto(new { IsDeleted = true }).ExecuteAffrowsAsync();
        }
    }
}