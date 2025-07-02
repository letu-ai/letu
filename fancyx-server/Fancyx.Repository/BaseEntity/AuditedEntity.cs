using FreeSql.DataAnnotations;

namespace Fancyx.Repository.BaseEntity
{
    public abstract class AuditedEntity : CreationEntity
    {
        public DateTime? LastModificationTime { get; set; }

        [Column(IsNullable = true)]
        public Guid? LastModifierId { get; set; }
    }
}