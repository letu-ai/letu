using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Positions.Dtos
{
    public class PositionGroupDto
    {
        /// <summary>
        /// ID
        /// </summary>
        public Guid? Id { get; set; }

        /// <summary>
        /// �ϼ�����ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// ��������
        /// </summary>
        [Required]
        [MaxLength(64)]
        public string? GroupName { get; set; }

        /// <summary>
        /// ��ע
        /// </summary>
        [MaxLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// ����ֵ
        /// </summary>
        public int Sort { get; set; }
    }
}