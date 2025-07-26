using Letu.Admin.Entities.System;
using Letu.Admin.IService.System.LogManagement;
using Letu.Admin.IService.System.LogManagement.Dtos;
using Letu.Repository;

namespace Letu.Admin.Service.System.LogManagement
{
    public class LoginLogService : ILoginLogService
    {
        private readonly IRepository<LoginLogDO> _loginLogRepository;

        public LoginLogService(IRepository<LoginLogDO> loginLogRepository)
        {
            _loginLogRepository = loginLogRepository;
        }

        public async Task<PagedResult<LoginLogListDto>> GetLoginLogListAsync(LoginLogQueryDto dto)
        {
            var rows = await _loginLogRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName.Contains(dto.UserName!))
                .WhereIf(dto.Status == 1, x => x.IsSuccess)
                .WhereIf(dto.Status == 2, x => !x.IsSuccess)
                .WhereIf(!string.IsNullOrEmpty(dto.Address), x => x.Address != null && x.Address.Contains(dto.Address!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<LoginLogListDto>();

            return new PagedResult<LoginLogListDto>(total, rows);
        }
    }
}