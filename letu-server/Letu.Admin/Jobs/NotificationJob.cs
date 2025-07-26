using Letu.Admin.Entities.System;
using Letu.Admin.SharedService;
using Letu.Core.AutoInject;
using Letu.Job;
using Letu.Repository;
using FreeRedis;
using Quartz;
using RedLockNet.SERedis;

namespace Letu.Admin.Jobs
{
    [DenpendencyInject(AsSelf = true)]
    [JobKey("NotificationJob")]
    public class NotificationJob : IJob
    {
        private readonly ILogger<NotificationJob> _logger;
        private readonly IRepository<NotificationDO> _repository;
        private readonly MqttSharedService _mqttService;
        private readonly IRedisClient _database;
        private readonly RedLockFactory redLockFactory;

        public NotificationJob(ILogger<NotificationJob> logger, IRepository<NotificationDO> repository, MqttSharedService mqttService, IRedisClient database
            , RedLockFactory redLockFactory)
        {
            _logger = logger;
            _repository = repository;
            _mqttService = mqttService;
            _database = database;
            this.redLockFactory = redLockFactory;
        }

        public async Task Execute(IJobExecutionContext context)
        {
            try
            {
                var expiry = TimeSpan.FromSeconds(30);
                var wait = TimeSpan.FromSeconds(10);
                var retry = TimeSpan.FromSeconds(1);

                using var redLock = await redLockFactory.CreateLockAsync(nameof(NotificationJob), expiry, wait, retry);
                if (redLock.IsAcquired)
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