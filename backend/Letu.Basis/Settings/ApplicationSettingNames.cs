namespace Letu.Basis.Settings;

public static class ApplicationSettingNames
{
    private const string Prefix = "Letu.Application";

    public static class Site
    {
        private const string SitePrefix = Prefix + ".Site";
        public const string SiteUrl = SitePrefix + ".SiteUrl";
        public const string Title = SitePrefix + ".Title";
        public const string Favicon = SitePrefix + ".Favicon";
        public const string Logo = SitePrefix + ".Logo";
        public const string LogoText = SitePrefix + ".LogoText";
        public const string Copyright = SitePrefix + ".Copyright";
        public const string PrimaryColor = SitePrefix + ".PrimaryColor";
        public const string Icp = SitePrefix + ".Icp";
        public const string Description = SitePrefix + ".Description";
        public const string Keywords = SitePrefix + ".Keywords";
    }
}