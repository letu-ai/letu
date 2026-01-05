import { useRouter, type ErrorComponentProps } from '@tanstack/react-router';
import { Alert, Button } from 'antd';

const RouteErrorComponent = ({ error }: ErrorComponentProps) => {
    const router = useRouter();
        
    const handleRetry = () => {
        router.invalidate();
    };

    return (
        <div className='h-screen'>
            <Alert
                type="error"
                title="页面加载出错了，请联系管理员！"
                description={error.message}
                showIcon
                action={<Button size="small" danger onClick={handleRetry}>重试</Button>}
            />
        </div>
    );
};

export default RouteErrorComponent;
