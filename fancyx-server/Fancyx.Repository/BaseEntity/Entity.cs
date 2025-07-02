using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Fancyx.Repository.BaseEntity
{
    public abstract class Entity
    {
        [NotNull]
        [Required]
        [Column(IsPrimary = true)]
        public virtual Guid Id { get; set; }
    }
}