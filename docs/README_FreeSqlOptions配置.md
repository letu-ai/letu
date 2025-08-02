# FreeSqlOptions 配置指南

## 功能说明

采用ABP框架标准的Options模式，让其他模块可以通过 `FreeSqlOptions` 配置FreeSql实例。这种方式更符合ABP框架的设计理念，支持依赖注入和配置的统一管理。

## 核心类

### `FreeSqlOptions`
FreeSql配置选项类，提供以下功能：
- `ConfigureActions`: 存储配置Action的列表
- `AddConfigureAction(Action<IFreeSql>)`: 添加配置Action
- `ClearConfigureActions()`: 清空配置Action（用于测试）

### `FreeSqlFactory`
FreeSql工厂类，从依赖注入容器中获取 `FreeSqlOptions` 并执行配置。

## 使用方式

### 1. 在模块中配置FreeSqlOptions

```csharp
using Letu.Repository;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.Modularity;

[DependsOn(typeof(YourDependencyModule))]
public class YourModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        // 使用Options模式配置FreeSql
        context.Services.Configure<FreeSqlOptions>(options =>
        {
            // 添加实体配置
            options.AddConfigureAction(freeSql =>
            {
                // 配置审计日志
                freeSql.ConfigureAuditLogging();
                
                // 配置后台任务
                freeSql.ConfigureBackgroundJobs();
                
                // 自定义实体配置
                freeSql.Aop.ConfigEntity<MyEntity>(eb =>
                {
                    eb.Property(e => e.Name).StringLength(100);
                    eb.HasIndex(e => e.Code).IsUnique();
                    eb.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
                });
                
                // 配置全局过滤器
                freeSql.GlobalFilter.Apply<IMyFilter>("MyFilter", x => x.IsActive);
            });
        });
    }
}
```

### 2. 链式配置多个Action

```csharp
context.Services.Configure<FreeSqlOptions>(options =>
{
    options
        .AddConfigureAction(freeSql => freeSql.ConfigureAuditLogging())
        .AddConfigureAction(freeSql => freeSql.ConfigureBackgroundJobs())
        .AddConfigureAction(freeSql => 
        {
            // 更复杂的配置
            freeSql.Aop.ConfigEntity<User>(eb =>
            {
                eb.Property(e => e.Email).StringLength(255);
                eb.HasIndex(e => e.Email).IsUnique();
            });
        });
});
```

### 3. 条件配置

```csharp
context.Services.Configure<FreeSqlOptions>(options =>
{
    // 开发环境特殊配置
    if (context.Services.GetHostingEnvironment().IsDevelopment())
    {
        options.AddConfigureAction(freeSql =>
        {
            // 开发环境下的额外配置
            freeSql.Aop.TraceBefore = (s, e) => Console.WriteLine(e.Sql);
        });
    }
    
    // 生产环境配置
    if (context.Services.GetHostingEnvironment().IsProduction())
    {
        options.AddConfigureAction(freeSql =>
        {
            // 生产环境下的性能优化配置
            freeSql.Aop.CommandTimeout = 60;
        });
    }
});
```

## 执行流程

1. **模块注册阶段**: 各个模块在 `ConfigureServices` 方法中通过 `Configure<FreeSqlOptions>` 注册配置Action
2. **Factory创建阶段**: `FreeSqlFactory.Create()` 从依赖注入容器获取 `FreeSqlOptions` 实例
3. **配置执行阶段**: Factory按注册顺序执行所有配置Action

## 优势

### 1. **符合ABP标准**
- 使用标准的Options模式
- 完全集成到ABP的依赖注入系统
- 支持配置验证和绑定

### 2. **更好的可测试性**
```csharp
// 测试中可以轻松mock配置
var options = new FreeSqlOptions();
options.AddConfigureAction(freeSql => /* 测试配置 */);
```

### 3. **配置的集中管理**
- 所有配置都通过依赖注入系统管理
- 支持从配置文件读取设置
- 便于集成到配置管理系统

### 4. **更好的模块化**
- 每个模块独立配置自己的FreeSql部分
- 避免了静态依赖
- 支持动态配置修改

## 注意事项

1. **配置顺序**: 配置Action按照模块注册的顺序执行
2. **异常处理**: 如果某个配置Action抛出异常，会影响FreeSql实例的创建
3. **性能考虑**: 配置Action在每次创建FreeSql实例时都会执行，避免重复的重型操作

## 示例项目结构

```
YourProject/
├── YourProject.Core/           # 实体定义
├── YourProject.Repository/     # 仓储实现
├── YourProject.FreeSql.Config/ # FreeSql配置模块
│   ├── YourProjectFreeSqlModule.cs
│   └── EntityConfigurations/
│       ├── UserConfiguration.cs
│       └── OrderConfiguration.cs
└── YourProject.Web/           # Web层
```

每个模块都可以独立配置自己相关的FreeSql设置，实现真正的模块化架构。