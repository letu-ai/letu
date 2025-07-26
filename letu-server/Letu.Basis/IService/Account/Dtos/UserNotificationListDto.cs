﻿namespace Letu.Basis.IService.Account.Dtos
{
    public class UserNotificationListDto
    {
        public Guid Id { get; set; }

        /// <summary>
        /// 通知标题
        /// </summary>
        public string? Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        public string? Content { get; set; }

        /// <summary>
        /// 通知员工
        /// </summary>
        public Guid EmployeeId { get; set; }

        /// <summary>
        /// 是否已读(1已读0未读)
        /// </summary>
        public bool IsReaded { get; set; }

        public DateTime CreationTime { get; set; }

        /// <summary>
        /// 已读时间
        /// </summary>
        public DateTime? ReadedTime { get; set; }
    }
}
