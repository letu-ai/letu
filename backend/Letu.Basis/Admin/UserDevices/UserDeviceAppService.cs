using Letu.Basis.Admin.UserDevices.Dtos;
using Letu.Basis.Identity;
using Letu.Core.Applications;
using Letu.Repository;
using Microsoft.Extensions.Localization;
using Volo.Abp;
using Volo.Abp.Users;

namespace Letu.Basis.Admin.UserDevices;

public class UserDeviceAppService : BasisAppService, IUserDeviceAppService
{
    private readonly IFreeSqlRepository<UserDevice> userDeviceRepository;

    public UserDeviceAppService(
        IFreeSqlRepository<UserDevice> userDeviceRepository
    )
    {
        this.userDeviceRepository = userDeviceRepository;
    }

    public async Task SaveUserDeviceAsync(SaveUserDeviceInput input)
    {
        var currentUserId = CurrentUser.GetId();

        // 查找是否已存在该设备记录
        var existingDevice = await userDeviceRepository.Select
            .Where(x => x.UserId == currentUserId && x.DeviceId == input.DeviceId && x.PackageName == input.PackageName)
            .FirstAsync();

        if (existingDevice != null)
        {
            // 更新现有设备信息
            existingDevice.DeviceName = input.DeviceName ?? existingDevice.DeviceName;
            existingDevice.ClientType = input.ClientType;
            existingDevice.AppVersion = input.AppVersion ?? existingDevice.AppVersion;
            existingDevice.PushDeviceId = input.PushDeviceId ?? existingDevice.PushDeviceId;
            existingDevice.PushDeviceToken = input.PushDeviceToken ?? existingDevice.PushDeviceToken;
            existingDevice.LastActiveTime = Clock.Now;

            await userDeviceRepository.UpdateAsync(existingDevice);
        }
        else
        {
            // 创建新设备记录
            var newDevice = new UserDevice
            {
                UserId = currentUserId,
                TenantId = CurrentTenant.Id,
                DeviceId = input.DeviceId,
                PackageName = input.PackageName,
                DeviceName = input.DeviceName,
                ClientType = input.ClientType,
                AppVersion = input.AppVersion,
                PushDeviceId = input.PushDeviceId,
                PushDeviceToken = input.PushDeviceToken,
                LastActiveTime = Clock.Now
            };

            await userDeviceRepository.InsertAsync(newDevice);
        }
    }

    public async Task<PagedResult<UserDeviceListOutput>> GetUserDeviceListAsync(UserDeviceListInput input)
    {
        var items = await userDeviceRepository.Select
            .WhereIf(input.UserId.HasValue, x => x.UserId == input.UserId!.Value)
            .WhereIf(!string.IsNullOrEmpty(input.UserName), x => x.User!.UserName.Contains(input.UserName!))
            .WhereIf(input.ClientType.HasValue, x => x.ClientType == input.ClientType!.Value)
            .WhereIf(!string.IsNullOrEmpty(input.PackageName), x => x.PackageName == input.PackageName)
            .Count(out var total)
            .Page(input.Current, input.PageSize)
            .OrderByDescending(x => x.LastActiveTime)
            .ToListAsync(x => new UserDeviceListOutput
            {
                Id = x.Id,
                UserId = x.UserId,
                UserName = x.User!.UserName,
                UserNickName = x.User!.NickName,
                ClientType = x.ClientType,
                PackageName = x.PackageName,
                DeviceId = x.DeviceId,
                DeviceName = x.DeviceName,
                PushDeviceId = x.PushDeviceId,
                AppVersion = x.AppVersion,
                LastActiveTime = x.LastActiveTime,
                CreationTime = x.CreationTime
            });

        return new PagedResult<UserDeviceListOutput>(total, items);
    }

    public async Task DeleteUserDeviceAsync(string deviceId, string packageName)
    {
        var currentUserId = CurrentUser.GetId();

        // 查找设备记录
        var device = await userDeviceRepository.Select
            .Where(x => x.UserId == currentUserId
                && x.DeviceId == deviceId
                && x.PackageName == packageName)
            .FirstAsync();

        if (device != null)
        {
            await userDeviceRepository.DeleteAsync(device);
        }
    }
}
