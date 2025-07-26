﻿using Letu.Core.Interfaces;
using System.Security.Claims;

namespace Letu.Core.Authorization
{
    public class CurrentUser : ICurrentUser
    {
        public Guid? Id => _id;

        public string? UserName => _userName;

        private readonly Guid? _id;
        private readonly string? _userName;
        private readonly IEnumerable<Claim>? _claims;

        public CurrentUser(Guid? id, string? userName, IEnumerable<Claim>? claims)
        {
            _id = id;
            _userName = userName;
            _claims = claims;
        }

        public Claim FindClaim(string type)
        {
            return _claims?.FirstOrDefault(x => x.Type == type) ?? new Claim(type, string.Empty);
        }

        public static ICurrentUser Default()
        {
            return new CurrentUser(null, null, null);
        }
    }
}