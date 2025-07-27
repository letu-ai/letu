using AutoMapper;
using Letu.Core.Utils;

namespace Letu.Core.Helpers
{
    public class AutoMapperHelper
    {
        private static readonly Lazy<IMapper> lazyInstance = new(() => _mapper!);

        public static IMapper Instance => lazyInstance.Value;

        private static readonly IMapper _mapper;

        static AutoMapperHelper()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.AddMaps(ReflectionUtils.AllAssemblies);
            });

            _mapper = config.CreateMapper();
        }
    }
}