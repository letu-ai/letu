/**
 * 通知详情页面
 */
import React, { useEffect, useState } from 'react';
import { ScrollView, TouchableOpacity } from 'react-native';
import { VStack } from '@/components/ui/vstack';
import { HStack } from '@/components/ui/hstack';
import { Heading } from '@/components/ui/heading';
import { Text } from '@/components/ui/text';
import { Spinner } from '@/components/ui/spinner';
import { Icon } from '@/components/ui/icon';
import { ArrowLeftIcon } from '@/components/ui/icon';
import { useNavigation, useRoute, type RouteProp } from '@react-navigation/native';
import type { HomeStackParamList } from '@/navigation/MainNavigator';
import {
  getNotificationDetail,
  markAsRead,
  type IMyNotificationListDto
} from '@/api/notification';
import { useNotificationStore } from '@/stores/notificationStore';
import dayjs from 'dayjs';

type NotificationDetailRouteProp = RouteProp<HomeStackParamList, 'NotificationDetail'>;

export default function NotificationDetailScreen() {
  const navigation = useNavigation();
  const route = useRoute<NotificationDetailRouteProp>();
  const { id } = route.params;

  const [notification, setNotification] = useState<IMyNotificationListDto | null>(null);
  const [loading, setLoading] = useState(true);

  // 集成notificationStore
  const decreaseUnreadCount = useNotificationStore((state) => state.decreaseUnreadCount);

  useEffect(() => {
    loadNotificationDetail();
  }, [id]);

  const loadNotificationDetail = async () => {
    try {
      setLoading(true);
      const detail = await getNotificationDetail(id);
      setNotification(detail);

      // 自动标记为已读
      if (!detail.isReaded) {
        await markAsRead([id]);
        setNotification({ ...detail, isReaded: true });
        // 更新未读计数
        decreaseUnreadCount(1);
      }
    } catch (error) {
      console.error('加载通知详情失败:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleGoBack = () => {
    navigation.goBack();
  };

  if (loading) {
    return (
      <VStack className="flex-1 items-center justify-center bg-background-0">
        <Spinner size="large" />
      </VStack>
    );
  }

  if (!notification) {
    return (
      <VStack className="flex-1 items-center justify-center bg-background-0">
        <Text size="lg" className="text-typography-400">
          通知不存在
        </Text>
      </VStack>
    );
  }

  return (
    <VStack className="flex-1 bg-background-0">
      {/* 头部导航栏 */}
      <HStack className="p-4 bg-background-50 border-b border-outline-100 items-center">
        <TouchableOpacity onPress={handleGoBack} className="mr-3">
          <Icon as={ArrowLeftIcon} size="xl" />
        </TouchableOpacity>
        <Heading size="lg" className="flex-1">
          通知详情
        </Heading>
      </HStack>

      {/* 通知内容 */}
      <ScrollView className="flex-1">
        <VStack className="p-6" space="lg">
          {/* 标题 */}
          <VStack space="sm">
            <Heading size="xl">{notification.title}</Heading>
            <Text size="sm" className="text-typography-400">
              {dayjs(notification.creationTime).format('YYYY-MM-DD HH:mm')}
            </Text>
          </VStack>

          {/* 内容 */}
          {notification.content && (
            <VStack className="py-4">
              <Text size="md" className="text-typography-700 leading-6">
                {notification.content}
              </Text>
            </VStack>
          )}

          {/* 扩展数据 - 如果有的话 */}
          {notification.extensionData && (
            <VStack className="p-4 bg-background-100 rounded-lg">
              <Text size="sm" className="text-typography-500">
                扩展信息
              </Text>
              <Text size="sm" className="text-typography-700 mt-2">
                {notification.extensionData}
              </Text>
            </VStack>
          )}
        </VStack>
      </ScrollView>
    </VStack>
  );
}
