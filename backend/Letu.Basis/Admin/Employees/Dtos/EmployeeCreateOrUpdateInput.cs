using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.Employees.Dtos;

public class EmployeeCreateOrUpdateInput
{

    /// <summary>
    /// 姓名
    /// </summary>
    [NotNull]
    [Required]
    [MaxLength(64)]
    public string? Name { get; set; }

    /// <summary>
    /// 工号
    /// </summary>
    [NotNull]
    [Required]
    [MaxLength(64)]
    public string? Code { get; set; }

    /// <summary>
    /// 性别
    /// </summary>
    [Required]
    public SexType Sex { get; set; }


    /// <summary>
    /// 身份证
    /// </summary>
    [MaxLength(32)]
    public string? IdNo { get; set; }

    /// <summary>
    /// 身份证正面
    /// </summary>
    [MaxLength(512)]
    public string? FrontIdNoUrl { get; set; }

    /// <summary>
    /// 身份证背面
    /// </summary>
    [MaxLength(512)]
    public string? BackIdNoUrl { get; set; }

    /// <summary>
    /// 生日
    /// </summary>
    public DateTime? Birthday { get; set; }

    /// <summary>
    /// 现住址
    /// </summary>
    [StringLength(512)]
    public string? Address { get; set; }

    /// <summary>
    /// 入职时间
    /// </summary>
    public DateOnly? InTime { get; set; }

    /// <summary>
    /// 离职时间
    /// </summary>
    public DateOnly? OutTime { get; set; }

    /// <summary>
    /// 是否离职
    /// </summary>
    public int Status { get; set; }




}