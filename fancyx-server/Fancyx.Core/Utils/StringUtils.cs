using Newtonsoft.Json.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Fancyx.Core.Utils
{
    public static partial class StringUtils
    {
        public static bool IgnoreCaseEquals(string? value1, string? value2, bool ignoreCase = false)
        {
            return string.Equals(value1, value2, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// 随机字符串
        /// </summary>
        /// <param name="len">字符长度</param>
        /// <param name="isNumber">是否纯数字</param>
        /// <param name="isWord">是否纯字母</param>
        /// <param name="hasChar">是否含特殊符号</param>
        /// <returns></returns>
        public static string RandomStr(int len, bool isNumber = false, bool isWord = false, bool hasChar = false)
        {
            var sb = new StringBuilder();
            if (isNumber)
            {
                Random r = new Random();
                for (int i = 0; i < len; i++)
                {
                    sb.Append(r.Next(0, 10));
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// 小写加下划线命名转帕斯卡命名
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string ToPascalCase(string input)
        {
            if (string.IsNullOrEmpty(input) || !input.Contains('_'))
                return input;

            // 使用StringBuilder来构建结果字符串
            StringBuilder pascalCase = new StringBuilder();

            // 分割字符串
            string[] words = input.Split('_');

            // 遍历每个单词，并将其首字母大写
            foreach (string word in words)
            {
                if (word.Length > 0)
                {
                    pascalCase.Append(char.ToUpperInvariant(word[0]));
                    if (word.Length > 1)
                    {
                        pascalCase.Append(word.Substring(1).ToLowerInvariant());
                    }
                }
            }

            return pascalCase.ToString();
        }

        public static string? XssFilte(string? input)
        {
            if (string.IsNullOrEmpty(input)) return input;

            // 使用正则表达式移除潜在的XSS攻击代码
            // 注意：以下正则表达式只是一个简单的例子，可能不会覆盖所有XSS攻击向量
            // 考虑使用HtmlSanitizer

            input = ScriptRegex().Replace(input, string.Empty);
            input = InputRegex().Replace(input, string.Empty);
            input = StyleRegex().Replace(input, string.Empty);
            input = IframeRegex().Replace(input, string.Empty);
            input = SrcRegex().Replace(input, "src=\"\"");

            return input;
        }

        /// <summary>
        /// 脱敏方法（如：替换为 *，保留最后几位）
        /// </summary>
        /// <param name="data"></param>
        /// <param name="keepLast"></param>
        /// <returns></returns>
        public static string MaskSensitiveData(string data, int keepLast = 4)
        {
            if (string.IsNullOrEmpty(data) || data.Length <= keepLast)
                return new string('*', data.Length);

            return string.Concat(new string('*', data.Length - keepLast), data.AsSpan(data.Length - keepLast));
        }

        [GeneratedRegex(@"<script.*?>.*?</script.*?>", RegexOptions.IgnoreCase | RegexOptions.Singleline, "zh-CN")]
        private static partial Regex ScriptRegex();

        [GeneratedRegex(@"<input.*?/>", RegexOptions.IgnoreCase, "zh-CN")]
        private static partial Regex InputRegex();
        [GeneratedRegex(@"<style.*?>.*?</style.*?>", RegexOptions.IgnoreCase | RegexOptions.Singleline, "zh-CN")]
        private static partial Regex StyleRegex();

        [GeneratedRegex(@"<iframe.*?>.*?</iframe.*?>", RegexOptions.IgnoreCase | RegexOptions.Singleline, "zh-CN")]
        private static partial Regex IframeRegex();

        [GeneratedRegex(@"src[\s]*=[\s]*['""]?javascript:", RegexOptions.IgnoreCase, "zh-CN")]
        private static partial Regex SrcRegex();
    }
}