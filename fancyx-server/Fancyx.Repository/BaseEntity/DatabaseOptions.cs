using FreeSql.Aop;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Repository.BaseEntity
{
    public class DatabaseOptions
    {
        [NotNull]
        public string? ConnectionString { get; set; }

        public EventHandler<AuditValueEventArgs>? AuditValue { get; set; }
    }
}