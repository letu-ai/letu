using FreeSql.DataAnnotations;

namespace Letu.Repository.BaseEntity
{
    public abstract class FullAuditedEntity : AuditedEntity, IDeletionProperty
    {
        [Column(IsNullable = false)]
        public bool IsDeleted { get; set; } = false;

        [Column(IsNullable = true)]
        public Guid? DeleterId { get; set; }

        public DateTime? DeletionTime { get; set; }

        public void Delete(Guid deleterId)
        {
            IsDeleted = true;
            DeleterId = deleterId;
            DeletionTime = DateTime.Now;
        }
    }
}