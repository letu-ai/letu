/**
 * 首页
 */
import React from 'react';
import { VStack } from '@/components/ui/vstack';
import { Heading } from '@/components/ui/heading';
import { Text } from '@/components/ui/text';
import { useAuthStore } from '@/stores/authStore';

export default function HomeScreen() {
  const user = useAuthStore((state) => state.user);

  return (
    <VStack space="lg" className="flex-1 p-6 bg-background-0">
      <VStack space="md">
        <Heading size="xl">欢迎回来</Heading>
        {user?.nickName && (
          <Text size="lg" className="text-typography-600">
            {user.nickName}
          </Text>
        )}
      </VStack>
    </VStack>
  );
}

