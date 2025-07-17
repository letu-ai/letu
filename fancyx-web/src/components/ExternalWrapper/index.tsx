import { useLocation } from 'react-router-dom';
import ExternalFrame from '@/components/ExternalFrame';

const ExternalWrapper = () => {
  const { pathname } = useLocation();
  // 提取URL，例如 /external/https://google.com 变成 https://google.com
  const externalUrl = pathname.replace('/external/', '');

  return <ExternalFrame url={externalUrl} />;
};

export default ExternalWrapper;
