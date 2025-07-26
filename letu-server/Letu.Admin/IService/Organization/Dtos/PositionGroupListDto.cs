using System.Text.Json.Serialization;

namespace Letu.Admin.IService.Organization.Dtos
{
    public class PositionGroupListDto
    {
        /// <summary>
        /// 数据ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 分组名
        /// </summary>
        public string? GroupName { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        public string? Remark { get; set; }

        /// <summary>
        /// 父ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 层级父ID
        /// </summary>
        public string? ParentIds { get; set; }

        /// <summary>
        /// 排序值
        /// </summary>
        public int Sort { get; set; }

        [JsonIgnore]
        [Newtonsoft.Json.JsonIgnore]
        public List<PositionGroupListDto>? Rawchildren { get; set; }

        public List<PositionGroupListDto>? Children => Rawchildren != null && Rawchildren.Count > 0 ? Rawchildren : null;
    }
}