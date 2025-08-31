//using FreeRedis;
//using Letu.Basis.Admin.NotificationManagement;
//using Letu.Basis.SharedService;
//using Letu.Job;
//using Letu.Repository;
//using Quartz;
//using Volo.Abp.DependencyInjection;
//using Volo.Abp.DistributedLocking;

//namespace Letu.Basis.Jobs
//{
//    [JobKey("NotificationJob")]
//    public class NotificationJob : IJob, ISingletonDependency
//    {
//        private readonly ILogger<NotificationJob> logger;
//        private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
//        private readonly IFreeSqlRepository<Notification> notificationRepository;
//        private readonly MqttSharedService mqttService;
//        private readonly IRedisClient database;
//        private readonly IAbpDistributedLock distributedLock;

//        public NotificationJob(
//            ILogger<NotificationJob> logger, 
//            IFreeSqlRepository<UserNotification> userNotificationRepository,
//            IFreeSqlRepository<Notification> notificationRepository,
//            MqttSharedService mqttService, 
//            IRedisClient database, 
//            IAbpDistributedLock distributedLock)
//        {
//            this.logger = logger;
//            this.userNotificationRepository = userNotificationRepository;
//            this.notificationRepository = notificationRepository;
//            this.mqttService = mqttService;
//            this.database = database;
//            this.distributedLock = distributedLock;
//        }

//        public async Task Execute(IJobExecutionContext context)
//        {
//            try
//            {
//                var timeout = TimeSpan.FromSeconds(30);
//                var wait = TimeSpan.FromSeconds(10);
//                var retry = TimeSpan.FromSeconds(1);

//                await using var handle = await distributedLock.TryAcquireAsync(nameof(NotificationJob), timeout);
//                if (handle != null)
//                {
//                    var unreadNotifications = await userNotificationRepository.Select
//                        .From<Notification>()
//                        .InnerJoin((un, n) => un.NotificationId == n.Id)
//                        .Where((un, n) => !un.IsRead && !un.IsDeleted)
//                        .ToListAsync((un, n) => new { 
//                            UserNotificationId = un.Id,
//                            UserId = un.UserId, 
//                            NotificationId = n.Id,
//                            Title = n.Title, 
//                            Content = n.Content,
//                            Priority = n.Priority
//                        });

//                    var groupMap = unreadNotifications.GroupBy(x => x.UserId).ToDictionary(k => k.Key, v => v.ToList());
//                    var random = new Random();
                    
//                    if (unreadNotifications.Count > 0)
//                    {
//                        foreach (var userGroup in groupMap)
//                        {
//                            var userId = userGroup.Key;
//                            var userNotifications = userGroup.Value;
//                            var unreadCount = userNotifications.Count;

//                            var index = random.Next(0, userNotifications.Count);
//                            var selectedNotification = userNotifications[index];
//                            var lastNotiKey = "LastNotification" + userId;

//                            if (await database.ExistsAsync(lastNotiKey))
//                            {
//                                var lastNotiId = await database.GetAsync<string>(lastNotiKey);
//                                if (lastNotiId == selectedNotification.UserNotificationId.ToString() && userNotifications.Count > 1)
//                                {
//                                    if (index < userNotifications.Count - 1)
//                                    {
//                                        selectedNotification = userNotifications[index + 1];
//                                    }
//                                }
//                            }

//                            var pushData = new { 
//                                title = selectedNotification.Title, 
//                                content = selectedNotification.Content, 
//                                priority = selectedNotification.Priority,
//                                NoReadedCount = unreadCount 
//                            };
                            
//                            var isSuc = await mqttService.PushAsync("Notification:" + userId, pushData);
//                            if (!isSuc) continue;

//                            await database.SetAsync("LastNotification" + userId, selectedNotification.UserNotificationId.ToString(), TimeSpan.FromMinutes(1));
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                logger.LogError(ex, "NotificationJob发生错误");
//            }
//        }
//    }
//}