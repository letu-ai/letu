using Letu.Basis.Entities.Organization;
using Letu.Basis.Entities.System;
using Letu.Basis.IService.Account;
using Letu.Basis.IService.Account.Dtos;
using Letu.Core.Interfaces;
using Letu.Repository;

namespace Letu.Basis.Service.Account
{
    public class UserNotificationService : IUserNotificationService, IScopedDependency
    {
        private readonly IRepository<NotificationDO> _repository;
        private readonly IRepository<EmployeeDO> _employeeRepository;
        private readonly ICurrentUser _currentUser;

        public UserNotificationService(IRepository<NotificationDO> repository, IRepository<EmployeeDO> employeeRepository, ICurrentUser currentUser)
        {
            _repository = repository;
            _employeeRepository = employeeRepository;
            _currentUser = currentUser;
        }

        public async Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto)
        {
            var employeeId = await this.GetCurrentEmployeeIdAsync();
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
            var employeeId = await this.GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return result;

            var query = _repository.Where(x => x.EmployeeId == employeeId);
            result.Items = await query.OrderBy(x => x.IsReaded).OrderByDescending(x => x.CreationTime)
                .Take(5).ToListAsync<UserNotificationNavbarItemDto>();
            result.NoReadedCount = (int)await query.Where(x => !x.IsReaded).CountAsync();

            return result;
        }

        public async Task ReadedAsync(Guid[] ids)
        {
            var employeeId = await this.GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return;

            var now = DateTime.Now;
            await _repository.UpdateDiy.Set(x => x.IsReaded, true)
                .Set(x => x.ReadedTime, now)
                .Where(x => x.EmployeeId == employeeId && ids.Contains(x.Id))
                .ExecuteAffrowsAsync();
        }

        private async Task<Guid?> GetCurrentEmployeeIdAsync()
        {
            return await _employeeRepository.Where(x => x.UserId.HasValue && x.UserId == _currentUser.Id).ToOneAsync(x => x.Id);
        }
    }
}