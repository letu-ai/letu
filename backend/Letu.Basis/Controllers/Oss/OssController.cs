using Letu.Core.Helpers;
using Letu.ObjectStorage;
using Letu.Shared.Keys;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Oss
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
        public async Task<string> UploadAsync(IFormFile file)
        {
            using var stream = file.OpenReadStream();

            var fileName = file.FileName;
            if (HttpContext.Request.Headers.TryGetValue("dir", out var dir) && !string.IsNullOrWhiteSpace(dir))
            {
                fileName = dir + "/" + fileName;
            }

            //var storageType = await _configSharedService.GetAsync(SystemConfigKey.StorageType);
            //_ = Enum.TryParse(storageType, out StorageType type);
            var type = StorageType.Local;
            IObjectStorageService objectStorageService = _objectStorageFactory.GetService(type);
            var url = await objectStorageService.UploadAsync(stream, fileName);

            if (type == StorageType.Local)
            {
                url = $"file/{url}";
            }

            return url;
        }

        [HttpGet]
        [Route("/file/{*fileName}")]
        public async Task<IActionResult> ImageAsync([FromRoute] string fileName)
        {
            try
            {
                //var storageType = await _configSharedService.GetAsync(SystemConfigKey.StorageType);
                //_ = Enum.TryParse(storageType, out StorageType type);
                var type = StorageType.Local;
                IObjectStorageService objectStorageService = _objectStorageFactory.GetService(type);
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

        [Authorize]
        [HttpDelete]
        public async Task DeleteAsync([FromQuery] string key)
        {
            IObjectStorageService objectStorageService = _objectStorageFactory.GetService(StorageType.Local);
            await objectStorageService.DeleteAsync(key);
        }
    }
}