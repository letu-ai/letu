import { TreeSelect } from 'antd';
import { useEffect, useState } from 'react';
import { getOrganizationUnitList, buildOrganizationUnitTree, type OrganizationUnitTreeNode } from '@/pages/admin/organization-units/-service';

interface OrganizationUnitSelectProps {
    value?: string;
    onChange?: (value: string | undefined) => void;
    placeholder?: string;
    initialLabel?: string;
    allowClear?: boolean;
    style?: React.CSSProperties;
}

export default function OrganizationUnitSelect({
    value,
    onChange,
    placeholder = '请选择组织机构',
    initialLabel,
    allowClear = true,
    style
}: OrganizationUnitSelectProps) {
    const [treeData, setTreeData] = useState<OrganizationUnitTreeNode[]>([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        loadOrganizationUnits();
    }, []);

    const loadOrganizationUnits = async () => {
        setLoading(true);
        try {
            const data = await getOrganizationUnitList({});
            const tree = buildOrganizationUnitTree(data);
            setTreeData(tree);
        } catch (error) {
            console.error('Failed to load organization units:', error);
        } finally {
            setLoading(false);
        }
    };

    const convertToTreeSelectData = (nodes: OrganizationUnitTreeNode[]): any[] => {
        return nodes.map(node => ({
            value: node.id,
            title: node.name,
            children: node.children ? convertToTreeSelectData(node.children) : undefined
        }));
    };

    return (
        <TreeSelect
            value={value}
            defaultValue={initialLabel}
            onChange={onChange}
            placeholder={placeholder}
            allowClear={allowClear}
            treeData={convertToTreeSelectData(treeData)}
            loading={loading}
            style={style}
            treeDefaultExpandAll
            showSearch
            filterTreeNode={(search, item) => {
                const title = item.title?.toString();
                if (title) {
                    return title.toLowerCase().indexOf(search.toLowerCase()) >= 0;
                }
                return false;
            }}
        />
    );
}