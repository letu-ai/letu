using Fancyx.Core.Helpers;
using Fancyx.ObjectStorage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Fancyx.Admin.Controllers.Oss
{
    [Route("api/[controller]/[action]")]
    public class OssController : ControllerBase
    {
        private readonly IObjectStorageFactory _objectStorageFactory;

        public OssController(IObjectStorageFactory objectStorageFactory)
        {
            _objectStorageFactory = objectStorageFactory;
        }

        [HttpPost]
        [Authorize]
        public async Task<AppResponse<string>> UploadAsync(IFormFile file)
        {
            using var stream = file.OpenReadStream();

            var fileName = file.FileName;
            if (HttpContext.Request.Headers.TryGetValue("dir", out var dir) && !string.IsNullOrWhiteSpace(dir))
            {
                fileName = dir + "/" + fileName;
            }
            IObjectStorageService objectStorageService = _objectStorageFactory.GetService(StorageType.Local);
            var url = await objectStorageService.UploadAsync(stream, fileName);

            //目前默认是本地服务器模式，后续读取配置
            url = $"file/{url}";

            return Result.Data(url);
        }

        [HttpGet]
        [Route("/file/{*fileName}")]
        public async Task<IActionResult> ImageAsync([FromRoute] string fileName)
        {
            try
            {
                IObjectStorageService objectStorageService = _objectStorageFactory.GetService(StorageType.Local);
                var stream = await objectStorageService.DownloadAsync(fileName);
                var name = Path.GetFileName(fileName);
                var mimeType = MimeTypesMapHelper.Instance.GetMimeType(name);
                return File(stream, mimeType, name);
            }
            catch (Exception)
            {
                return NotFound();
            }
        }

        [HttpDelete]
        public async Task<AppResponse<bool>> DeleteAsync([FromQuery] string key)
        {
            IObjectStorageService objectStorageService = _objectStorageFactory.GetService(StorageType.Local);
            await objectStorageService.DeleteAsync(key);
            return Result.Ok();
        }
    }
}