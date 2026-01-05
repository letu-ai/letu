/**
 * 登录页面
 */
import React, { useEffect, useState } from 'react';
import { KeyboardAvoidingView, Platform, ScrollView } from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigation } from '@react-navigation/native';
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
import { Checkbox, CheckboxIndicator, CheckboxLabel, CheckboxIcon } from '@/components/ui/checkbox';
import { useToast, Toast, ToastTitle, ToastDescription } from '@/components/ui/toast';
import { useAuthStore } from '@/stores/authStore';
import { storage } from '@/utils/storage';
import { loginByPassword } from '@/pages/auth/service';
import { Check } from 'lucide-react-native';

const loginSchema = z.object({
  userName: z.string().min(1, '请输入用户名'),
  password: z.string().min(1, '请输入密码'),
  rememberMe: z.boolean().default(false).optional(),
});

type LoginFormData = z.infer<typeof loginSchema>;

export default function LoginScreen() {
  const navigation = useNavigation();
  const toast = useToast();
  const [loading, setLoading] = useState(false);
  const login = useAuthStore((state) => state.login);

  const {
    control,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      userName: '',
      password: '',
      rememberMe: false,
    },
  });

  const rememberMe = watch('rememberMe');

  useEffect(() => {
    // 加载记住的用户名
    const loadRememberedData = async () => {
      const rememberedUsername = await storage.getRememberedUsername();
      const rememberMeValue = await storage.getRememberMe();
      if (rememberedUsername) {
        setValue('userName', rememberedUsername);
        setValue('rememberMe', rememberMeValue);
      }
    };
    loadRememberedData();
  }, [setValue]);

  const onSubmit = async (data: LoginFormData) => {
    setLoading(true);
    try {
      const result = await loginByPassword({
        userName: data.userName,
        password: data.password,
        rememberMe: data.rememberMe,
      });

      await login(result, data.rememberMe);

      // 处理记住我
      if (data.rememberMe) {
        await storage.setRememberedUsername(data.userName);
        await storage.setRememberMe(true);
      } else {
        await storage.clearRememberMe();
      }

      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="success" variant="solid">
              <ToastTitle>登录成功</ToastTitle>
            </Toast>
          );
        },
      });
    } catch (error: any) {
      const errorMessage = error?.response?.data?.error?.message || error?.message || '登录失败，请重试';
      toast.show({
        placement: 'top',
        render: ({ id }) => {
          return (
            <Toast nativeID={`toast-${id}`} action="error" variant="solid">
              <ToastTitle>登录失败</ToastTitle>
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
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1 }}
    >
      <ScrollView
        contentContainerStyle={{
          flexGrow: 1,
          justifyContent: 'center',
          padding: 24,
          backgroundColor: '#ffffff',
        }}
        keyboardShouldPersistTaps="handled"
      >
        <VStack space="xl" className="w-full">
          <VStack space="md" className="items-center mb-8">
            <Heading size="2xl" className="text-center">
              欢迎登录
            </Heading>
            <Text size="md" className="text-typography-500 text-center">
              请输入您的账号和密码
            </Text>
          </VStack>

          <VStack space="lg">
            <FormControl isInvalid={!!errors.userName}>
              <FormControlLabel>
                <FormControlLabelText>用户名</FormControlLabelText>
              </FormControlLabel>
              <Controller
                control={control}
                name="userName"
                render={({ field: { onChange, onBlur, value } }) => (
                  <Input>
                    <InputField
                      placeholder="请输入用户名"
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                      autoCapitalize="none"
                      autoCorrect={false}
                    />
                  </Input>
                )}
              />
              <FormControlError>
                <FormControlErrorText>{errors.userName?.message}</FormControlErrorText>
              </FormControlError>
            </FormControl>

            <FormControl isInvalid={!!errors.password}>
              <FormControlLabel>
                <FormControlLabelText>密码</FormControlLabelText>
              </FormControlLabel>
              <Controller
                control={control}
                name="password"
                render={({ field: { onChange, onBlur, value } }) => (
                  <Input>
                    <InputField
                      placeholder="请输入密码"
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
                <FormControlErrorText>{errors.password?.message}</FormControlErrorText>
              </FormControlError>
            </FormControl>

            <Controller
              control={control}
              name="rememberMe"
              render={({ field: { onChange, value } }) => (
                <Checkbox
                  value="remember"
                  isChecked={value}
                  onChange={(isChecked) => onChange(isChecked)}
                >
                  <CheckboxIndicator>
                    <CheckboxIcon as={Check} />
                  </CheckboxIndicator>
                  <CheckboxLabel>记住我</CheckboxLabel>
                </Checkbox>
              )}
            />

            <Button
              onPress={handleSubmit(onSubmit)}
              isDisabled={loading}
              size="lg"
              className="mt-4"
            >
              <ButtonText>{loading ? '登录中...' : '登录'}</ButtonText>
            </Button>
          </VStack>
        </VStack>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

