using FreeSql;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Domain.Repositories;

namespace Letu.Repository;

public abstract class FreeSqlBasicRepositoryBase<TEntity> : BaseRepository<TEntity>, IBasicRepository<TEntity>
    where TEntity : class, IEntity
{
    public FreeSqlBasicRepositoryBase(IFreeSql fsql) : base(fsql)
    {
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public bool? IsChangeTrackingEnabled => null;

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task DeleteAsync(TEntity entity, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.DeleteAsync(entity, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task DeleteManyAsync(IEnumerable<TEntity> entities, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.DeleteAsync(entities, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public Task<long> GetCountAsync(CancellationToken cancellationToken = default)
    {
        return base.Select.CountAsync(cancellationToken);
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public Task<List<TEntity>> GetListAsync(bool includeDetails = false, CancellationToken cancellationToken = default)
    {
        return base.Select.ToListAsync(cancellationToken);
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public Task<List<TEntity>> GetPagedListAsync(int skipCount, int maxResultCount, string sorting, bool includeDetails = false, CancellationToken cancellationToken = default)
    {
        var query = base.Select.Skip(skipCount).Take(maxResultCount);
        if (!string.IsNullOrWhiteSpace(sorting))
        {
            query = query.OrderBy(sorting);
        }
        return query.ToListAsync(cancellationToken);
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task<TEntity> InsertAsync(TEntity entity, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.InsertAsync(entity, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
        return entity;
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task InsertManyAsync(IEnumerable<TEntity> entities, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.InsertAsync(entities, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task<TEntity> UpdateAsync(TEntity entity, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.UpdateAsync(entity, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
        return entity;
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task UpdateManyAsync(IEnumerable<TEntity> entities, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        await base.UpdateAsync(entities, cancellationToken);
        // autoSave 参数在FreeSql中由UnitOfWork管理，此处不需要手动提交
    }
}

public abstract class FreeSqlBasicRepositoryBase<TEntity, TKey> : FreeSqlBasicRepositoryBase<TEntity>, IBasicRepository<TEntity, TKey>
    where TEntity : class, IEntity<TKey>
{

    public FreeSqlBasicRepositoryBase(IFreeSql fsql) : base(fsql)
    { 
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public virtual async Task<TEntity> GetAsync(TKey id, bool includeDetails = true, CancellationToken cancellationToken = default)
    {
        var entity = await FindAsync(id, includeDetails, cancellationToken);

        if (entity == null)
        {
            throw new EntityNotFoundException(typeof(TEntity), id);
        }

        return entity;
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public virtual Task<TEntity?> FindAsync(TKey id, bool includeDetails = true, CancellationToken cancellationToken = default)
    {
        return base.Select
            .Where(e => e.Id!.Equals(id))
            .FirstAsync(cancellationToken)!;
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public virtual async Task DeleteAsync(TKey id, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        var entity = await FindAsync(id, cancellationToken: cancellationToken);
        if (entity == null)
        {
            return;
        }

        await DeleteAsync(entity, autoSave, cancellationToken);
    }

    [Obsolete("兼容Abp.IBasicRepository保留的方法，请使用FreeSql BaseRepository提供的方法。")]
    public async Task DeleteManyAsync(IEnumerable<TKey> ids, bool autoSave = false, CancellationToken cancellationToken = default)
    {
        foreach (var id in ids)
        {
            await DeleteAsync(id, cancellationToken: cancellationToken);
        }
    }
}