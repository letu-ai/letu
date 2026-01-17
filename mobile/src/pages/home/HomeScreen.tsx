/**
 * 首页
 */
import React, { useEffect } from 'react';
import { TouchableOpacity } from 'react-native';
import { VStack } from '@/components/ui/vstack';
import { HStack } from '@/components/ui/hstack';
import { Heading } from '@/components/ui/heading';
import { Text } from '@/components/ui/text';
import { Badge } from '@/components/ui/badge';
import { BadgeText } from '@/components/ui/badge';
import { Icon } from '@/components/ui/icon';
import { Bell } from 'lucide-react-native';
import { useAuthStore } from '@/stores/authStore';
import { useNotificationStore } from '@/stores/notificationStore';
import { useNavigation } from '@react-navigation/native';
import type { StackNavigationProp } from '@react-navigation/stack';
import type { HomeStackParamList } from '@/navigation/MainNavigator';

type HomeScreenNavigationProp = StackNavigationProp<HomeStackParamList, 'HomeMain'>;

export default function HomeScreen() {
  const navigation = useNavigation<HomeScreenNavigationProp>();
  const user = useAuthStore((state) => state.user);
  const unreadCount = useNotificationStore((state) => state.unreadCount);
  const fetchUnreadCount = useNotificationStore((state) => state.fetchUnreadCount);

  // 进入页面时获取未读计数
  useEffect(() => {
    fetchUnreadCount();
  }, [fetchUnreadCount]);

  // 跳转到通知列表
  const handleNotificationPress = () => {
    navigation.navigate('NotificationList');
  };

  return (
    <VStack className="flex-1 bg-background-0">
      {/* 顶部导航栏 */}
      <HStack className="p-4 bg-background-50 border-b border-outline-100 justify-between items-center">
        <Heading size="xl">主页</Heading>
        <TouchableOpacity onPress={handleNotificationPress} className="relative">
          <Icon as={Bell} size="xl" className="text-typography-700" />
          {unreadCount > 0 && (
            <Badge
              size="sm"
              variant="solid"
              action="error"
              className="absolute -top-1 -right-1 min-w-[18px] h-[18px] rounded-full items-center justify-center"
            >
              <BadgeText className="text-xs">
                {unreadCount > 99 ? '99+' : unreadCount}
              </BadgeText>
            </Badge>
          )}
        </TouchableOpacity>
      </HStack>

      {/* 主内容区 */}
      <VStack space="lg" className="flex-1 p-6">
        <VStack space="md">
          <Heading size="xl">欢迎回来</Heading>
          {user?.nickName && (
            <Text size="lg" className="text-typography-600">
              {user.nickName}
            </Text>
          )}
        </VStack>
      </VStack>
    </VStack>
  );
}
