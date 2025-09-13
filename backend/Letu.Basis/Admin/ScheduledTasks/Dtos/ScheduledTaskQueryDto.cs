using Letu.Core.Applications;

namespace Letu.Basis.IService.System.Dtos
{
    public class ScheduledTaskQueryDto: PagedResultRequest
    {
        /// <summary>
        /// 任务KEY
        /// </summary>
        public string? TaskKey { get; set; }

        /// <summary>
        /// 任务描述
        /// </summary>
        public string? Description { get; set; }
    }
}