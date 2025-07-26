using Microsoft.Extensions.DependencyModel;
using System.Reflection;
using System.Runtime.Loader;

namespace Letu.Core.Utils
{
    public class ReflectionUtils
    {
        /// <summary>
        /// 获取项目程序集，排除所有的系统程序集(Microsoft.***、System.***等)、Nuget下载包
        /// </summary>
        /// <returns></returns>
        public static IList<Assembly> AllAssemblies
        {
            get;
            private set;
        }

        static ReflectionUtils()
        {
            var list = new List<Assembly>();
            var deps = DependencyContext.Default;
            if (deps == null)
            {
                AllAssemblies = [];
                return;
            }
            var libs = deps.CompileLibraries.Where(lib => !lib.Serviceable && lib.Type != "package");//排除所有的系统程序集、Nuget下载包
            foreach (var lib in libs)
            {
                try
                {
                    var assembly = AssemblyLoadContext.Default.LoadFromAssemblyName(new AssemblyName(lib.Name));
                    list.Add(assembly);
                }
                catch (Exception)
                {
                    // ignored
                }
            }
            AllAssemblies = list;
        }

        /// <summary>
        /// 同属性名赋值（基于反射）
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TTarget"></typeparam>
        /// <param name="source">源对象</param>
        /// <param name="target">目标对象</param>
        /// <param name="ignoreProps">忽略属性</param>
        public static void CopyTo<TSource, TTarget>(TSource source, TTarget target, params string[] ignoreProps)
        {
            if (source == null || target == null) return;
            var sourceType = typeof(TSource);
            var targetType = typeof(TTarget);
            ignoreProps ??= [];
            var map = new Dictionary<string, object?>();
            foreach (var sourceProp in sourceType.GetProperties())
            {
                map.Add(sourceProp.Name, sourceProp.GetValue(source));
            }
            foreach (var targetProp in targetType.GetProperties())
            {
                string propName = targetProp.Name;
                if (ignoreProps.Contains(propName)) continue;
                if (map.TryGetValue(propName, out object? value))
                {
                    //Convert.ChangeType(value, targetProp.PropertyType)
                    targetProp.SetValue(target, value);
                }
            }
        }
    }
}