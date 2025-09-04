namespace Letu.Basis.Personal.Profiles.Dtos;

public class ProfileOutput
{
    public required string NickName { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public string? Avatar { get; set; }

    public bool HasPassword { get; set; }
}
