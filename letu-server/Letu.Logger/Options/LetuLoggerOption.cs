namespace Letu.Logger.Options
{
    public class LetuLoggerOption
    {
        /// <summary>
        /// 忽略的异常类型列表（忽略异常错误日志不会收集）
        /// </summary>
        public Type[]? IgnoreExceptionTypes { get; set; }
    }
}