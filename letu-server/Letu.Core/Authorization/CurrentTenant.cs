using Letu.Core.Interfaces;

namespace Letu.Core.Authorization
{
    public class CurrentTenant : ICurrentTenant
    {
        private readonly string? _tenantId;
        public string? TenantId => _tenantId;

        public CurrentTenant(string? name)
        {
            _tenantId = name;
        }
    }
}