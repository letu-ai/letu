/**
 * 修改密码页面
 */
import React, { useState } from 'react';
import { ScrollView } from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { VStack } from '@/components/ui/vstack';
import { Heading } from '@/components/ui/heading';
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
import { useToast, Toast, ToastTitle, ToastDescription } from '@/components/ui/toast';
import { useNavigation } from '@react-navigation/native';
import { changePassword } from './service';
import { useAuthStore } from '@/stores/authStore';
import type { StackNavigationProp } from '@react-navigation/stack';
import type { ProfileStackParamList } from '@/navigation/MainNavigator';

type PasswordScreenNavigationProp = StackNavigationProp<ProfileStackParamList, 'Password'>;

const passwordSchema = z
  .object({
    oldPassword: z.string().min(1, '请输入当前密码'),
    newPassword: z.string().min(6, '密码长度至少6位'),
    confirmPassword: z.string().min(1, '请确认新密码'),
  })
  .refine((data) => data.newPassword === data.confirmPassword, {
    message: '两次输入的密码不一致',
    path: ['confirmPassword'],
  });

type PasswordFormData = z.infer<typeof passwordSchema>;

export default function PasswordScreen() {
  const navigation = useNavigation<PasswordScreenNavigationProp>();
  const toast = useToast();
  const [loading, setLoading] = useState(false);
  const logout = useAuthStore((state) => state.logout);

  const {
    control,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<PasswordFormData>({
    resolver: zodResolver(passwordSchema),
    defaultValues: {
      oldPassword: '',
      newPassword: '',
      confirmPassword: '',
    },
  });

  const onSubmit = async (data: PasswordFormData) => {
    setLoading(true);
    try {
      await changePassword({
        oldPassword: data.oldPassword,
        newPassword: data.newPassword,
      });

      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="success" variant="solid">
              <ToastTitle>修改成功</ToastTitle>
              <ToastDescription>密码已修改，请重新登录</ToastDescription>
            </Toast>
          );
        },
      });

      reset();
      // 延迟一下让用户看到成功提示
      setTimeout(async () => {
        await logout();
      }, 1500);
    } catch (error: any) {
      const errorMessage = error?.response?.data?.error?.message || error?.message || '修改失败';
      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="error" variant="solid">
              <ToastTitle>修改失败</ToastTitle>
              <ToastDescription>{errorMessage}</ToastDescription>
            </Toast>
          );
        },
      });
    } finally {
      setLoading(false);
    }
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
        <VStack space="md">
          <Heading size="lg">修改密码</Heading>
          <Text size="sm" className="text-typography-500">
            请确保新密码强度足够，修改成功后需要重新登录
          </Text>
        </VStack>

        <VStack space="lg">
          <FormControl isInvalid={!!errors.oldPassword}>
            <FormControlLabel>
              <FormControlLabelText>当前密码</FormControlLabelText>
            </FormControlLabel>
            <Controller
              control={control}
              name="oldPassword"
              render={({ field: { onChange, onBlur, value } }) => (
                <Input>
                  <InputField
                    placeholder="请输入当前密码"
                    value={value}
                    onChangeText={onChange}
                    onBlur={onBlur}
                    secureTextEntry
                    autoCapitalize="none"
                    autoCorrect={false}
                  />
                </Input>
              )}
            />
            <FormControlError>
              <FormControlErrorText>{errors.oldPassword?.message}</FormControlErrorText>
            </FormControlError>
          </FormControl>

          <FormControl isInvalid={!!errors.newPassword}>
            <FormControlLabel>
              <FormControlLabelText>新密码</FormControlLabelText>
            </FormControlLabel>
            <Controller
              control={control}
              name="newPassword"
              render={({ field: { onChange, onBlur, value } }) => (
                <Input>
                  <InputField
                    placeholder="请输入新密码（至少6位）"
                    value={value}
                    onChangeText={onChange}
                    onBlur={onBlur}
                    secureTextEntry
                    autoCapitalize="none"
                    autoCorrect={false}
                  />
                </Input>
              )}
            />
            <FormControlError>
              <FormControlErrorText>{errors.newPassword?.message}</FormControlErrorText>
            </FormControlError>
          </FormControl>

          <FormControl isInvalid={!!errors.confirmPassword}>
            <FormControlLabel>
              <FormControlLabelText>确认新密码</FormControlLabelText>
            </FormControlLabel>
            <Controller
              control={control}
              name="confirmPassword"
              render={({ field: { onChange, onBlur, value } }) => (
                <Input>
                  <InputField
                    placeholder="请再次输入新密码"
                    value={value}
                    onChangeText={onChange}
                    onBlur={onBlur}
                    secureTextEntry
                    autoCapitalize="none"
                    autoCorrect={false}
                  />
                </Input>
              )}
            />
            <FormControlError>
              <FormControlErrorText>{errors.confirmPassword?.message}</FormControlErrorText>
            </FormControlError>
          </FormControl>

          <Button
            onPress={handleSubmit(onSubmit)}
            isDisabled={loading}
            size="lg"
            className="mt-4"
          >
            <ButtonText>{loading ? '修改中...' : '确认修改'}</ButtonText>
          </Button>
        </VStack>
      </VStack>
    </ScrollView>
  );
}

