import { Alert, Button } from 'antd';
import type { FallbackProps } from 'react-error-boundary';

const ErrorFallback = ({ error, resetErrorBoundary }: FallbackProps) => {
    return (
        <div
            className='flex justify-center items-center h-full mx-auto'
        >
            <Alert
                type="error"
                title="页面加载出错了，请联系管理员！"
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
