using Letu.Applications;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Notifications;
using Letu.Basis.Personal.Notifications.Dtos;
using Letu.Repository;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Personal.Notifications
{
    public class UserNotificationAppService : BasisAppService, IUserNotificationAppService
    {
        private readonly IFreeSqlRepository<Notification> _repository;
        private readonly IFreeSqlRepository<Employee> _employeeRepository;

        public UserNotificationAppService(IFreeSqlRepository<Notification> repository, IFreeSqlRepository<Employee> employeeRepository)
        {
            _repository = repository;
            _employeeRepository = employeeRepository;
        }

        public async Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto)
        {
            var employeeId = await GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return new PagedResult<UserNotificationListDto>();

            var list = await _repository
                .Where(x => x.EmployeeId == employeeId)
                .WhereIf(!string.IsNullOrEmpty(dto.Title), x => x.Title!.Contains(x.Title))
                .WhereIf(dto.IsReaded.HasValue, x => x.IsReaded == dto.IsReaded)
                .OrderBy(x => x.IsReaded)
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<UserNotificationListDto>();
            return new PagedResult<UserNotificationListDto>(dto, total, list);
        }

        public async Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync()
        {
            var result = new UserNotificationNavbarDto();
            var employeeId = await GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return result;

            var query = _repository.Where(x => x.EmployeeId == employeeId);
            result.Items = await query.OrderBy(x => x.IsReaded).OrderByDescending(x => x.CreationTime)
                .Take(5).ToListAsync<UserNotificationNavbarItemDto>();
            result.NoReadedCount = (int)await query.Where(x => !x.IsReaded).CountAsync();

            return result;
        }

        public async Task ReadedAsync(Guid[] ids)
        {
            var employeeId = await GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return;

            var now = DateTime.Now;
            await _repository.UpdateDiy.Set(x => x.IsReaded, true)
                .Set(x => x.ReadedTime, now)
                .Where(x => x.EmployeeId == employeeId && ids.Contains(x.Id))
                .ExecuteAffrowsAsync();
        }

        private async Task<Guid?> GetCurrentEmployeeIdAsync()
        {
            return await _employeeRepository.Where(x => x.UserId.HasValue && x.UserId == CurrentUser.Id).ToOneAsync(x => x.Id);
        }
    }
}