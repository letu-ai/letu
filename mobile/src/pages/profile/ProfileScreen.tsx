/**
 * 个人资料页面
 */
import React, { useEffect, useState } from 'react';
import { ScrollView, Platform } from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { launchImageLibrary, ImagePickerResponse } from 'react-native-image-picker';
import { VStack } from '@/components/ui/vstack';
import { Text } from '@/components/ui/text';
import { Input, InputField } from '@/components/ui/input';
import { Button, ButtonText } from '@/components/ui/button';
import {
  FormControl,
  FormControlLabel,
  FormControlLabelText,
  FormControlError,
  FormControlErrorText,
} from '@/components/ui/form-control';
import { Avatar, AvatarImage, AvatarFallbackText } from '@/components/ui/avatar';
import { useToast, Toast, ToastTitle, ToastDescription } from '@/components/ui/toast';
import { useNavigation } from '@react-navigation/native';
import { useAuthStore } from '@/stores/authStore';
import { getProfile, updateProfile, uploadAvatar } from './service';
import { logout as logoutService } from '@/pages/auth/service';
import type { ProfileStackParamList } from '@/navigation/MainNavigator';
import type { StackNavigationProp } from '@react-navigation/stack';
import type { IProfileOutput } from './service';

type ProfileScreenNavigationProp = StackNavigationProp<ProfileStackParamList, 'Profile'>;

const profileSchema = z.object({
  nickName: z.string().min(1, '请输入昵称'),
});

type ProfileFormData = z.infer<typeof profileSchema>;

export default function ProfileScreen() {
  const navigation = useNavigation<ProfileScreenNavigationProp>();
  const toast = useToast();
  const [loading, setLoading] = useState(false);
  const [profile, setProfile] = useState<IProfileOutput | null>(null);
  const [avatarUri, setAvatarUri] = useState<string | undefined>();
  const setUser = useAuthStore((state) => state.setUser);
  const logout = useAuthStore((state) => state.logout);

  const {
    control,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<ProfileFormData>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      nickName: '',
    },
  });

  useEffect(() => {
    loadProfile();
  }, []);

  const loadProfile = async () => {
    try {
      const data = await getProfile();
      setProfile(data);
      setValue('nickName', data.nickName);
      setAvatarUri(data.avatar);
      setUser({
        nickName: data.nickName,
        avatar: data.avatar,
      });
    } catch (error: any) {
      const errorMessage = error?.response?.data?.error?.message || error?.message || '加载失败';
      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="error" variant="solid">
              <ToastTitle>加载失败</ToastTitle>
              <ToastDescription>{errorMessage}</ToastDescription>
            </Toast>
          );
        },
      });
    }
  };

  const handleImagePicker = () => {
    launchImageLibrary(
      {
        mediaType: 'photo',
        quality: 0.8,
        maxWidth: 800,
        maxHeight: 800,
      },
      async (response: ImagePickerResponse) => {
        if (response.didCancel || response.errorCode) {
          return;
        }

        const asset = response.assets?.[0];
        if (!asset?.uri) {
          return;
        }

        try {
          setLoading(true);
          const file = {
            uri: Platform.OS === 'android' ? asset.uri : asset.uri.replace('file://', ''),
            type: asset.type || 'image/jpeg',
            name: asset.fileName || 'avatar.jpg',
          };

          const avatarUrl = await uploadAvatar(file);
          setAvatarUri(avatarUrl);
          setProfile((prev) => (prev ? { ...prev, avatar: avatarUrl } : null));
          setUser({
            nickName: profile?.nickName,
            avatar: avatarUrl,
          });

          toast.show({
            placement: 'top',
            render: ({ id }) => {
              return (
                <Toast nativeID={`toast-${id}`} action="success" variant="solid">
                  <ToastTitle>上传成功</ToastTitle>
                </Toast>
              );
            },
          });
        } catch (error: any) {
          const errorMessage = error?.response?.data?.error?.message || error?.message || '上传失败';
          toast.show({
            placement: 'top',
            render: ({ id }) => {
              return (
                <Toast nativeID={`toast-${id}`} action="error" variant="solid">
                  <ToastTitle>上传失败</ToastTitle>
                  <ToastDescription>{errorMessage}</ToastDescription>
                </Toast>
              );
            },
          });
        } finally {
          setLoading(false);
        }
      }
    );
  };

  const onSubmit = async (data: ProfileFormData) => {
    setLoading(true);
    try {
      await updateProfile({
        nickName: data.nickName,
        avatar: avatarUri,
      });

      setProfile((prev) => (prev ? { ...prev, nickName: data.nickName } : null));
      setUser({
        nickName: data.nickName,
        avatar: avatarUri,
      });

      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="success" variant="solid">
              <ToastTitle>保存成功</ToastTitle>
            </Toast>
          );
        },
      });
    } catch (error: any) {
      const errorMessage = error?.response?.data?.error?.message || error?.message || '保存失败';
      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="error" variant="solid">
              <ToastTitle>保存失败</ToastTitle>
              <ToastDescription>{errorMessage}</ToastDescription>
            </Toast>
          );
        },
      });
    } finally {
      setLoading(false);
    }
  };

  const getAvatarInitials = () => {
    if (profile?.nickName) {
      return profile.nickName.substring(0, 2).toUpperCase();
    }
    return 'U';
  };

  return (
    <ScrollView
      contentContainerStyle={{
        flexGrow: 1,
        padding: 24,
        backgroundColor: '#ffffff',
      }}
    >
      <VStack space="xl">
        <VStack space="md" className="items-center">
          <Avatar size="2xl">
            {avatarUri ? (
              <AvatarImage source={{ uri: avatarUri }} alt="头像" />
            ) : (
              <AvatarFallbackText>{getAvatarInitials()}</AvatarFallbackText>
            )}
          </Avatar>
          <Button
            onPress={handleImagePicker}
            variant="outline"
            size="sm"
            isDisabled={loading}
          >
            <ButtonText>更换头像</ButtonText>
          </Button>
        </VStack>

        <VStack space="lg">
          <FormControl isInvalid={!!errors.nickName}>
            <FormControlLabel>
              <FormControlLabelText>昵称</FormControlLabelText>
            </FormControlLabel>
            <Controller
              control={control}
              name="nickName"
              render={({ field: { onChange, onBlur, value } }) => (
                <Input>
                  <InputField
                    placeholder="请输入昵称"
                    value={value}
                    onChangeText={onChange}
                    onBlur={onBlur}
                  />
                </Input>
              )}
            />
            <FormControlError>
              <FormControlErrorText>{errors.nickName?.message}</FormControlErrorText>
            </FormControlError>
          </FormControl>

          {profile?.phone && (
            <VStack space="sm">
              <Text size="sm" className="text-typography-500">
                手机号
              </Text>
              <Input isReadOnly>
                <InputField value={profile.phone} />
              </Input>
            </VStack>
          )}

          {profile?.email && (
            <VStack space="sm">
              <Text size="sm" className="text-typography-500">
                邮箱
              </Text>
              <Input isReadOnly>
                <InputField value={profile.email} />
              </Input>
            </VStack>
          )}

          <Button
            onPress={handleSubmit(onSubmit)}
            isDisabled={loading}
            size="lg"
            className="mt-4"
          >
            <ButtonText>{loading ? '保存中...' : '保存'}</ButtonText>
          </Button>

          <Button
            onPress={() => navigation.navigate('Password')}
            variant="outline"
            size="lg"
          >
            <ButtonText>修改密码</ButtonText>
          </Button>

          <Button
            onPress={async () => {
              try {
                await logoutService();
                await logout();
                toast.show({
                  placement: 'top',
                  render: ({ id }) => {
                    return (
                      <Toast nativeID={`toast-${id}`} action="success" variant="solid">
                        <ToastTitle>已退出</ToastTitle>
                      </Toast>
                    );
                  },
                });
              } catch (error: any) {
                // 即使API调用失败，也清除本地状态
                await logout();
              }
            }}
            variant="outline"
            size="lg"
            action="negative"
            className="mt-4"
          >
            <ButtonText>退出登录</ButtonText>
          </Button>
        </VStack>
      </VStack>
    </ScrollView>
  );
}

