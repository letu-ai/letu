/**
 * 通知列表页面
 */
import React, { useEffect, useState, useCallback } from 'react';
import { FlatList, RefreshControl, TouchableOpacity } from 'react-native';
import { VStack } from '@/components/ui/vstack';
import { HStack } from '@/components/ui/hstack';
import { Heading } from '@/components/ui/heading';
import { Text } from '@/components/ui/text';
import { Badge } from '@/components/ui/badge';
import { BadgeText } from '@/components/ui/badge';
import { Divider } from '@/components/ui/divider';
import { Spinner } from '@/components/ui/spinner';
import { useNavigation } from '@react-navigation/native';
import type { StackNavigationProp } from '@react-navigation/stack';
import type { HomeStackParamList } from '@/navigation/MainNavigator';
import {
  getMyNotificationList,
  markAsRead,
  type IMyNotificationListDto
} from '@/api/notification';
import { useNotificationStore } from '@/stores/notificationStore';
import dayjs from 'dayjs';

const PAGE_SIZE = 20;

type NotificationListNavigationProp = StackNavigationProp<HomeStackParamList, 'NotificationList'>;

export default function NotificationListScreen() {
  const navigation = useNavigation<NotificationListNavigationProp>();
  const [notifications, setNotifications] = useState<IMyNotificationListDto[]>([]);
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const [page, setPage] = useState(0);

  // 集成notificationStore
  const shouldRefresh = useNotificationStore((state) => state.shouldRefresh);
  const clearShouldRefresh = useNotificationStore((state) => state.clearShouldRefresh);
  const decreaseUnreadCount = useNotificationStore((state) => state.decreaseUnreadCount);

  // 加载通知列表
  const loadNotifications = useCallback(async (pageNum: number, isRefresh: boolean = false) => {
    if (isRefresh) {
      setRefreshing(true);
    } else if (pageNum === 0) {
      setLoading(true);
    } else {
      setLoadingMore(true);
    }

    try {
      const result = await getMyNotificationList({
        skipCount: pageNum * PAGE_SIZE,
        maxResultCount: PAGE_SIZE,
      });

      if (isRefresh || pageNum === 0) {
        setNotifications(result.items);
      } else {
        setNotifications(prev => [...prev, ...result.items]);
      }

      setHasMore(result.items.length === PAGE_SIZE);
      setPage(pageNum);
    } catch (error) {
      console.error('加载通知列表失败:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
      setLoadingMore(false);
    }
  }, []);

  // 初始加载
  useEffect(() => {
    loadNotifications(0);
  }, [loadNotifications]);

  // 监听推送到达，自动刷新列表
  useEffect(() => {
    if (shouldRefresh) {
      console.log('检测到新推送，刷新通知列表');
      loadNotifications(0, true);
      clearShouldRefresh();
    }
  }, [shouldRefresh, loadNotifications, clearShouldRefresh]);

  // 下拉刷新
  const handleRefresh = useCallback(() => {
    loadNotifications(0, true);
  }, [loadNotifications]);

  // 加载更多
  const handleLoadMore = useCallback(() => {
    if (!loadingMore && hasMore && !refreshing) {
      loadNotifications(page + 1);
    }
  }, [loadingMore, hasMore, refreshing, page, loadNotifications]);

  // 点击通知
  const handleNotificationPress = async (notification: IMyNotificationListDto) => {
    // 跳转到详情页（修复：使用正确的类型，移除as never）
    navigation.navigate('NotificationDetail', { id: notification.id });

    // 如果未读，标记为已读
    if (!notification.isReaded) {
      try {
        await markAsRead([notification.id]);
        // 更新本地状态
        setNotifications(prev =>
          prev.map(n =>
            n.id === notification.id ? { ...n, isReaded: true } : n
          )
        );
        // 更新未读计数
        decreaseUnreadCount(1);
      } catch (error) {
        console.error('标记已读失败:', error);
      }
    }
  };

  // 渲染通知项
  const renderItem = ({ item }: { item: IMyNotificationListDto }) => (
    <TouchableOpacity onPress={() => handleNotificationPress(item)}>
      <VStack className="p-4 bg-background-0">
        <HStack className="justify-between items-start mb-2">
          <VStack className="flex-1 mr-2">
            <HStack className="items-center mb-1">
              <Text
                size="md"
                className={`flex-1 ${!item.isReaded ? 'font-semibold text-typography-900' : 'text-typography-700'}`}
                numberOfLines={2}
              >
                {item.title}
              </Text>
              {!item.isReaded && (
                <Badge size="sm" variant="solid" action="error" className="ml-2">
                  <BadgeText>未读</BadgeText>
                </Badge>
              )}
            </HStack>
            {item.content && (
              <Text
                size="sm"
                className="text-typography-500 mt-1"
                numberOfLines={2}
              >
                {item.content}
              </Text>
            )}
          </VStack>
        </HStack>
        <Text size="xs" className="text-typography-400">
          {dayjs(item.creationTime).format('YYYY-MM-DD HH:mm')}
        </Text>
      </VStack>
      <Divider />
    </TouchableOpacity>
  );

  // 渲染底部加载指示器
  const renderFooter = () => {
    if (!loadingMore) return null;
    return (
      <VStack className="p-4 items-center">
        <Spinner size="small" />
      </VStack>
    );
  };

  // 渲染空状态
  const renderEmpty = () => {
    if (loading) return null;
    return (
      <VStack className="flex-1 items-center justify-center p-8">
        <Text size="lg" className="text-typography-400">
          暂无通知
        </Text>
      </VStack>
    );
  };

  if (loading) {
    return (
      <VStack className="flex-1 items-center justify-center bg-background-0">
        <Spinner size="large" />
      </VStack>
    );
  }

  return (
    <VStack className="flex-1 bg-background-0">
      <VStack className="p-4 bg-background-50 border-b border-outline-100">
        <Heading size="xl">我的通知</Heading>
      </VStack>
      <FlatList
        data={notifications}
        renderItem={renderItem}
        keyExtractor={item => item.id}
        onEndReached={handleLoadMore}
        onEndReachedThreshold={0.5}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={handleRefresh} />
        }
        ListFooterComponent={renderFooter}
        ListEmptyComponent={renderEmpty}
      />
    </VStack>
  );
}
