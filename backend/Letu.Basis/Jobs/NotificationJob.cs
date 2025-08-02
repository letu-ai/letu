using FreeRedis;
using Letu.Basis.Admin.Notifications;
using Letu.Basis.SharedService;
using Letu.Job;
using Letu.Repository;
using Quartz;
using Volo.Abp.DependencyInjection;
using Volo.Abp.DistributedLocking;

namespace Letu.Basis.Jobs
{
    [JobKey("NotificationJob")]
    public class NotificationJob : IJob, ISingletonDependency
    {
        private readonly ILogger<NotificationJob> _logger;
        private readonly IFreeSqlRepository<Notification> _repository;
        private readonly MqttSharedService _mqttService;
        private readonly IRedisClient _database;
        private readonly IAbpDistributedLock distributedLock;

        public NotificationJob(ILogger<NotificationJob> logger, IFreeSqlRepository<Notification> repository, MqttSharedService mqttService, IRedisClient database, IAbpDistributedLock distributedLock)
        {
            _logger = logger;
            _repository = repository;
            _mqttService = mqttService;
            _database = database;
            this.distributedLock = distributedLock;
        }

        public async Task Execute(IJobExecutionContext context)
        {
            try
            {
                var timeout = TimeSpan.FromSeconds(30);
                var wait = TimeSpan.FromSeconds(10);
                var retry = TimeSpan.FromSeconds(1);

                await using var handle = await distributedLock.TryAcquireAsync(nameof(NotificationJob), timeout);
                if (handle != null)
                {
                    var notis = await _repository.Where(x => !x.IsReaded).ToListAsync();
                    var groupMap = notis.GroupBy(x => x.EmployeeId).ToDictionary(k => k.Key, v => v.Count());
                    var random = new Random();
                    if (notis.Count > 0)
                    {
                        foreach (var g in groupMap)
                        {
                            var curEmployeeNotis = notis.Where(x => x.EmployeeId == g.Key).ToList();
                            var index = random.Next(0, curEmployeeNotis.Count);
                            var item = curEmployeeNotis[index];
                            var lastNotiKey = "LastNotification" + item.EmployeeId;
                            if (await _database.ExistsAsync(lastNotiKey))
                            {
                                var lastNotiId = await _database.GetAsync<string>(lastNotiKey);
                                //随机取到了上条通知，就往后取一条
                                if (lastNotiId == item.Id.ToString() && curEmployeeNotis.Count > 1)
                                {
                                    if (index < curEmployeeNotis.Count - 1)
                                    {
                                        item = curEmployeeNotis[index + 1];
                                    }
                                }
                            }
                            var isSuc = await _mqttService.PushAsync("Notification:" + item.EmployeeId, new { title = item.Title, content = item.Content, NoReadedCount = g.Value });
                            if (!isSuc) continue;
                            //上条通知的ID
                            await _database.SetAsync("LastNotification" + item.EmployeeId, item.Id.ToString(), TimeSpan.FromMinutes(1));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "NotificationJob发生错误");
            }
        }
    }
}