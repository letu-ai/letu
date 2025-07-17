using Fancyx.Admin.Entities.Organization;
using Fancyx.Admin.Entities.System;
using Fancyx.Admin.IService.Account;
using Fancyx.Admin.IService.Account.Dtos;
using Fancyx.Core.Interfaces;
using Fancyx.Repository;

namespace Fancyx.Admin.Service.Account
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

            var list = await _repository.Select.From<EmployeeDO>().LeftJoin((n, e) => n.EmployeeId == e.Id)
                .Where((x, e) => x.EmployeeId == employeeId)
                .WhereIf(!string.IsNullOrEmpty(dto.Title), (x, e) => x.Title!.Contains(x.Title))
                .WhereIf(dto.IsReaded.HasValue, (x, e) => x.IsReaded == dto.IsReaded)
                .OrderByDescending((x, e) => x.CreationTime)
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

            var query = _repository.Where(x => x.EmployeeId == employeeId && !x.IsReaded);
            result.Items = await query.OrderByDescending(x => x.CreationTime).Take(5).ToListAsync<UserNotificationNavbarItemDto>();
            result.NoReadedCount = (int)await query.CountAsync();

            return result;
        }

        public async Task ReadedAsync(Guid[] ids)
        {
            var employeeId = await this.GetCurrentEmployeeIdAsync();
            if (!employeeId.HasValue) return;

            await _repository.UpdateDiy.Where(x => x.EmployeeId == employeeId && ids.Contains(x.Id)).SetDto(new { IsReaded = true }).ExecuteAffrowsAsync();
        }

        private async Task<Guid?> GetCurrentEmployeeIdAsync()
        {
            return await _employeeRepository.Where(x => x.UserId.HasValue && x.UserId == _currentUser.Id).ToOneAsync(x => x.Id);
        }
    }
}