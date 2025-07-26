import { Alert, Button } from 'antd';
import React from 'react';
import type { FallbackProps } from 'react-error-boundary';

const ErrorFallback: React.FC<FallbackProps> = ({ error, resetErrorBoundary }) => {
  return (
    <div
      style={{
        margin: '20px',
        textAlign: 'center',
      }}
    >
      <Alert
        type="error"
        message="页面加载出错了，请联系管理员！"
        description={error.message}
        showIcon
        action={
          <Button size="small" danger onClick={resetErrorBoundary}>
            重试
          </Button>
        }
      />
    </div>
  );
};

export default ErrorFallback;
