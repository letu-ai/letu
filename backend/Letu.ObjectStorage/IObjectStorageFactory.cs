namespace Letu.ObjectStorage
{
    public interface IObjectStorageFactory
    {
        IObjectStorageService GetService(StorageType storageType, StorageOptions? options = null);
    }
}