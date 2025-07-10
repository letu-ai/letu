namespace Fancyx.Shared.Consts
{
    public static class LogRecordConsts
    {
        public const string SysUser = "系统用户";
        public const string SysUserResetPwdSubType = "重置用户密码";
        public const string SysUserResetPwdContent = "重置用户{{userName}}登录密码";

        public const string SysDictType = "系统字典";
        public const string SysDictAddSubType = "新增字典";
        public const string SysDictAddContent = "新增字典{{dict.Name}}";
        public const string SysDictDeleteSubType = "删除字典";
        public const string SysDictDeleteContent = "删除字典：名称：{{dict.Name}}，类型：{{dict.DictType}}";
        public const string SysDictBatchDeleteSubType = "批量删除字典";
        public const string SysDictBatchDeleteContent = "批量删除ID为{{ids}}字典";

        public const string SysDictData = "字典数据";
        public const string SysDictDataUpdateSubType = "编辑字典数据";
        public const string SysDictDataUpdateContent = "编辑后：值={{after.Value}},启用={{after.IsEnabled}}";
        public const string SysDictDataDeleteSubType = "删除字典数据";
        public const string SysDictDataDeleteContent = "删除了{{ids}}字典项数据";
        
        public const string SysConfig = "配置管理";
        public const string SysConfigUpdateSubType = "编辑配置";
        public const string SysConfigUpdateContent = "编辑后：键={{after.Key}}，值={{after.Value}}，组={{after.GroupKey}}";
    }
}