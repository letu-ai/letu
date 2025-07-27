using Letu.Core.Interfaces;

namespace Letu.ObjectStorage
{
    public interface IObjectStorageFactory : ISingletonDependency
    {
        IObjectStorageService GetService(StorageType storageType, StorageOptions? options = null);
    }
}