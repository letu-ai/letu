# EF 事务与 UOW 集成流程

以下是从 HTTP 请求到事务提交的核心流程及涉及的关键类 / 方法（简化代码）：

### 1. HTTP 请求触发 UOW 创建（MVC 过滤器）

**类**：`AbpUowActionFilter`

**方法**：`OnActionExecutionAsync`



```csharp
// 拦截HTTP请求，创建UOW
public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
{
    var unitOfWorkManager = context.HttpContext.RequestServices.GetRequiredService<IUnitOfWorkManager>();
    using (var uow = unitOfWorkManager.Begin()) // 开始UOW
    {
        var result = await next(); // 执行控制器逻辑
        if (Succeed(result))
        {
            await uow.CompleteAsync(); // 提交事务
        }
        else
        {
            await uow.RollbackAsync();
        }
    }
}
```

### 2. UOW 初始化

**类**：`UnitOfWork`

**方法**：`Initialize`



```csharp
public void Initialize(AbpUnitOfWorkOptions options)
{
    Options = options;
    // 初始化数据库API和事务API容器
    _databaseApis = new Dictionary<string, IDatabaseApi>();
    _transactionApis = new Dictionary<string, ITransactionApi>();
}
```

### 3. EF 仓储操作触发 DatabaseApi 创建

**类**：`UnitOfWorkDbContextProvider<TDbContext>`

**方法**：`CreateDbContextAsync`



```csharp
public async Task<TDbContext> CreateDbContextAsync(IUnitOfWork unitOfWork)
{
    if (unitOfWork.Options.IsTransactional)
    {
        return await CreateDbContextWithTransactionAsync(unitOfWork); // 创建带事务的DbContext
    }
    return unitOfWork.ServiceProvider.GetRequiredService<TDbContext>();
}
```

### 4. TransactionApi 创建（绑定 EF 事务）

**类**：`UnitOfWorkDbContextProvider<TDbContext>`

**方法**：`CreateDbContextWithTransactionAsync`



```csharp
protected async Task<TDbContext> CreateDbContextWithTransactionAsync(IUnitOfWork unitOfWork)
{
    var dbContext = unitOfWork.ServiceProvider.GetRequiredService<TDbContext>();
    var transactionApiKey = $"EntityFrameworkCore_{dbContext.Database.GetConnectionString()}";
    
    // 开启EF事务并创建TransactionApi
    var dbTransaction = await dbContext.Database.BeginTransactionAsync();
    unitOfWork.AddTransactionApi(transactionApiKey, new EfCoreTransactionApi(dbTransaction, dbContext));
    
    // 创建并注册DatabaseApi
    unitOfWork.AddDatabaseApi(transactionApiKey, new EfCoreDatabaseApi(dbContext));
    
    return dbContext;
}
```

### 5. 仓储保存数据

**类**：`EfCoreRepository<TDbContext, TEntity>`

**方法**：`InsertAsync`



```csharp
public async Task<TEntity> InsertAsync(TEntity entity, bool autoSave = false, CancellationToken cancellationToken = default)
{
    var dbContext = await GetDbContextAsync();
    dbContext.Set<TEntity>().Add(entity);
    if (autoSave)
    {
        await dbContext.SaveChangesAsync(cancellationToken); // 保存到EF上下文（未提交到数据库）
    }
    return entity;
}
```

### 6. UOW 提交事务

**类**：`UnitOfWork`

**方法**：`CompleteAsync`



```csharp
public async Task CompleteAsync(CancellationToken cancellationToken = default)
{
    // 调用DatabaseApi保存数据,所以如果不是EfCore这种数据存在内存中的驱动，可以不用实现IDatabaseApi
    await SaveChangesAsync();
    
    // 提交所有事务
    await CommitTransactionsAsync(cancellationToken);
    IsCompleted = true;
}

protected async Task CommitTransactionsAsync(CancellationToken cancellationToken)
{
    foreach (var transaction in GetAllActiveTransactionApis())
    {
        await transaction.CommitAsync(cancellationToken); // 调用EfCoreTransactionApi提交
    }
}
```

### 7. EF 事务最终提交

**类**：`EfCoreTransactionApi`

**方法**：`CommitAsync`



```csharp
public async Task CommitAsync(CancellationToken cancellationToken = default)
{
    await DbContextTransaction.CommitAsync(cancellationToken); // 提交数据库事务
}
```
