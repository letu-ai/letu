namespace Letu.Basis.Account.Dtos;

public class ExternalProviderOutput
{
    public ExternalProviderOutput(string displayName, string authenticationScheme)
    {
        DisplayName = displayName;
        AuthenticationScheme = authenticationScheme;
    }

    public string DisplayName { get; }
    public string AuthenticationScheme { get; }
}

