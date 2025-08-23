﻿import * as icons from '@ant-design/icons';
import type { IconComponentProps } from '@ant-design/icons/lib/components/Icon';
import { Icon } from '@iconify/react';
import React from 'react';

interface IProIconProps {
  icon: string;
  className?: string;
}

const ProIcon = ({ className, icon }: IProIconProps) => {
  const arr = icon.split(':');
  const type = arr[0];
  const name = icon.substring(type.length + 1);

  if (type === 'antd') {
    const AntdIcon = icons[name as keyof typeof icons] as React.FC<IconComponentProps>;
    return AntdIcon ? <AntdIcon className={className} /> : null;
  } else if (type == 'iconify') {
    return <Icon icon={name} className={className} />;
  } else {
    return <span>icon-type not found</span>;
  }
};

export default ProIcon;
