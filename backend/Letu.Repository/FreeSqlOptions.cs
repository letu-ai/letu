using FreeSql;

namespace Letu.Repository
{
    /// <summary>
    /// FreeSql配置选项
    /// </summary>
    public class FreeSqlOptions
    {
        /// <summary>
        /// 存储模块预设的配置实体的Action列表
        /// </summary>
        public List<Action<IFreeSql>> ConfigureActions { get; } = new();

        /// <summary>
        /// 添加配置实体的Action
        /// </summary>
        /// <param name="configureAction">配置FreeSql实例的Action</param>
        public FreeSqlOptions AddConfigureAction(Action<IFreeSql> configureAction)
        {
            if (configureAction != null)
            {
                ConfigureActions.Add(configureAction);
            }
            return this;
        }

        /// <summary>
        /// 清空所有已注册的配置Action（主要用于测试场景）
        /// </summary>
        public FreeSqlOptions ClearConfigureActions()
        {
            ConfigureActions.Clear();
            return this;
        }
    }
}