import * as icons from '@ant-design/icons';
import { Icon } from '@iconify/react';
import React from "react";

const ProIcon = ({
  icon,
  width,
  height,
}: {
  icon: string;
  width?: number;
  height?: number;
}) => {
  const arr = icon.split(':');
  const type = arr[0];
  const name = arr[1];
  if (type === 'antd') {
    const AntdIcon = icons[name as keyof typeof icons] as React.FC;
    return AntdIcon ? <AntdIcon /> : null;
  } else if (type == 'iconify') {
    return <Icon icon={name} width={width} height={height} />;
  } else {
    return <span>icon-type not found</span>;
  }
};

export default ProIcon;
