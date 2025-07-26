using System.Security.Claims;

namespace Letu.Core.Interfaces
{
    public interface ICurrentUser
    {
        Guid? Id { get; }

        string? UserName { get; }

        Claim FindClaim(string type);
    }
}