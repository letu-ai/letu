﻿namespace Letu.Basis.Account.Dtos
{
    public class UserNotificationQueryDto : PageSearch
    {
        public string? Title { get; set; }

        public bool? IsReaded { get; set; }
    }
}