using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Repository.BaseEntity
{
    public abstract class CreationEntity : Entity
    {
        [NotNull]
        [Required]
        public Guid? CreatorId { get; set; }

        public DateTime CreationTime { get; set; }
    }
}