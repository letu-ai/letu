import { Button, Dropdown } from 'antd'
import ProIcon from '@/components/ProIcon';
import useLayoutStore, { isSizeType, type SizeType } from '@/application/layoutStore';
import type { MenuItemType } from 'antd/lib/menu/interface';
import { useMemo } from 'react';

interface ISizeItem extends MenuItemType {
    icon: React.ReactNode;
    key: SizeType;
    label: string;
}

const sizeItems: ISizeItem[] = [
    {
        key: 'large',
        icon: <ProIcon icon="antd:FontSizeOutlined" />,
        label: '大',
    },
    {
        key: 'middle',
        icon: <ProIcon icon="antd:FontSizeOutlined" />,
        label: '中',
    },
    {
        key: 'small',
        icon: <ProIcon icon="antd:FontSizeOutlined" />,
        label: '小',
    },
];

function SizeChanger() {
    const size = useLayoutStore(state => state.size);
    const setSize = useLayoutStore(state => state.setSize);

    const sizeDisplayText = useMemo(() => {
        return sizeItems.find((h) => h.key === size)?.label ?? '';
    }, [size]);

    const handleClick = ({ key }: { key: string }) => {
        if (isSizeType(key)) {
            setSize(key);
        }
    }

    return (
        <Dropdown
            classNames={{
                root: 'w-32',
            }}
            menu={{
                items: sizeItems,
                selectable: true,
                selectedKeys: [size],
                onClick: handleClick,
            }}
            trigger={['click']}
        >
            <Button type="text" className="">
                <ProIcon icon="antd:FontSizeOutlined" />
                {sizeDisplayText}
            </Button>
        </Dropdown>
    )
}

export default SizeChanger;