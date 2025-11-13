using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.Employees.Dtos
{
    public class EmployeeListOutput
    {
        /// <summary>
        /// ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 工号
        /// </summary>
        public string? Code { get; set; }

        /// <summary>
        /// 姓名
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        public SexType Sex { get; set; }


        /// <summary>
        /// 身份证
        /// </summary>
        public string? IdNo { get; set; }

        /// <summary>
        /// 身份证正面
        /// </summary>
        public string? FrontIdNoUrl { get; set; }

        /// <summary>
        /// 身份证背面
        /// </summary>
        public string? BackIdNoUrl { get; set; }

        /// <summary>
        /// 生日
        /// </summary>
        public DateTime? Birthday { get; set; }

        /// <summary>
        /// 现住址
        /// </summary>
        public string? Address { get; set; }


        /// <summary>
        /// 入职时间
        /// </summary>
        public DateTime? InTime { get; set; }

        /// <summary>
        /// 离职时间
        /// </summary>
        public DateTime? OutTime { get; set; }

        /// <summary>
        /// 是否离职
        /// </summary>
        public int Status { get; set; }

    }
}