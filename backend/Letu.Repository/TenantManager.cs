namespace Letu.Repository;

internal static class TenantManager
{
    // 注意一定是 static 静态化
    static AsyncLocal<Guid?> asyncLocal = new AsyncLocal<Guid?>();

    public static Guid? Current
    {
        get => asyncLocal.Value;
        set => asyncLocal.Value = value;
    }
}