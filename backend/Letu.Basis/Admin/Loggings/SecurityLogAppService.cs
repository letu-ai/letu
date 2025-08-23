using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Letu.Repository;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Loggings
{
    public class SecurityLogAppService : BasisAppService, ISecurityLogAppService
    {
        private readonly IFreeSqlRepository<SecurityLog> _loginLogRepository;

        public SecurityLogAppService(IFreeSqlRepository<SecurityLog> loginLogRepository)
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