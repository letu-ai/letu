using Fancyx.Core.Interfaces;

namespace Fancyx.ObjectStorage
{
    public interface IObjectStorageFactory : ISingletonDependency
    {
        IObjectStorageService GetService(StorageType storageType, StorageOptions? options = null);
    }
}