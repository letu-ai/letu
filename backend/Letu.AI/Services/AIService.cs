using Microsoft.Extensions.Configuration;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace Letu.AI.Services;

/// <summary>
/// AI 服务
/// TODO: 实现 OpenAI API 调用
/// 需要根据实际的 OpenAI SDK 版本调整实现
/// </summary>
public class AIService
{
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;
    private readonly string _apiBase;
    private readonly string _defaultModel;

    public AIService(IConfiguration configuration, IHttpClientFactory httpClientFactory)
    {
        _configuration = configuration;
        _httpClient = httpClientFactory.CreateClient();
        _apiKey = configuration["OpenAI:ApiKey"] ?? throw new InvalidOperationException("OpenAI API Key 未配置");
        _apiBase = configuration["OpenAI:ApiBase"] ?? "https://api.openai.com/v1";
        _defaultModel = configuration["OpenAI:Model"] ?? "gpt-4o";
        
        _httpClient.BaseAddress = new Uri(_apiBase);
        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _apiKey);
    }

    /// <summary>
    /// 调用 OpenAI API（非流式）
    /// TODO: 实现实际的 API 调用
    /// </summary>
    public async Task<string> CallAsync(string prompt, string? model = null)
    {
        // TODO: 实现 OpenAI API 调用
        throw new NotImplementedException("待实现 OpenAI API 调用");
    }

    /// <summary>
    /// 调用 OpenAI API（流式）
    /// TODO: 实现实际的流式 API 调用
    /// </summary>
    public async IAsyncEnumerable<string> CallStreamAsync(string prompt, string? model = null)
    {
        // TODO: 实现 OpenAI 流式 API 调用
        await Task.CompletedTask;
        yield break;
    }
}

