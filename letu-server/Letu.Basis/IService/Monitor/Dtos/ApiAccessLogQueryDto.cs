﻿namespace Letu.Basis.IService.Monitor.Dtos
{
    public class ApiAccessLogQueryDto : PageSearch
    {
        public string? UserName { get; set; }
        public string? Path { get; set; }
    }
}