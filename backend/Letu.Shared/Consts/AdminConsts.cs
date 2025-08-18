namespace Letu.Shared.Consts;

public static class AdminConsts
{
    public const string SuperAdminRole = "系统管理员";

    public const string AvatarFemale = "avatar/female.png";

    public const string AvatarMale = "avatar/male.png";

    public const double TokenExpiredHour = 1; //访问Token过期时间（时），必须大于前端token自动刷新判定时间
}