using Letu.Job.Database.Entities;
using Letu.Repository;
using Microsoft.Extensions.DependencyInjection;
using Quartz;
using System.Collections.Concurrent;

namespace Letu.Job
{
    internal class GlobalJobListener : IJobListener
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly BlockingCollection<TaskExecutionLogDO> _logQueue = [];
        private readonly CancellationTokenSource _cancellationTokenSource = new();

        public GlobalJobListener(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
            this.ProcessQueue();
        }

        public string Name => "GlobalJobListener";

        public Task JobExecutionVetoed(IJobExecutionContext context, CancellationToken cancellationToken = default)
        {
            if (cancellationToken.IsCancellationRequested)
            {
                _cancellationTokenSource.Cancel();
            }
            return Task.CompletedTask;
        }

        public Task JobToBeExecuted(IJobExecutionContext context, CancellationToken cancellationToken = default)
        {
            context.Put("ExecutionTime", DateTime.Now);

            if (cancellationToken.IsCancellationRequested)
            {
                _cancellationTokenSource.Cancel();
            }
            return Task.CompletedTask;
        }

        public Task JobWasExecuted(IJobExecutionContext context, JobExecutionException? jobException, CancellationToken cancellationToken = default)
        {
            var entity = new TaskExecutionLogDO()
            {
                TaskKey = JobKeyUtils.GetPureJobKey(context.JobDetail.Key.Name),
                ExecutionTime = (DateTime)context.Get("ExecutionTime")!,
                Status = jobException == null ? 1 : 2,
                Result = jobException?.Message ?? "成功",
            };
            entity.Cost = (int)Math.Round(DateTime.Now.Subtract(entity.ExecutionTime).TotalMilliseconds, 2);
            _logQueue.Add(entity, cancellationToken);

            if (cancellationToken.IsCancellationRequested)
            {
                _cancellationTokenSource.Cancel();
            }
            return Task.CompletedTask;
        }

        private void ProcessQueue()
        {
            IFreeSqlRepository<TaskExecutionLogDO>? repository = _serviceProvider.GetService<IFreeSqlRepository<TaskExecutionLogDO>>();

            Task.Run(() =>
            {
                var batch = new List<TaskExecutionLogDO>();
                while (!_cancellationTokenSource.IsCancellationRequested)
                {
                    if (_logQueue.TryTake(out var log, 500))
                    {
                        batch.Add(log);
                        if (batch.Count >= 500 || _logQueue.Count == 0)
                        {
                            repository?.Insert(batch);
                            batch.Clear();
                        }
                    }
                }
            }, _cancellationTokenSource.Token);
        }
    }
}