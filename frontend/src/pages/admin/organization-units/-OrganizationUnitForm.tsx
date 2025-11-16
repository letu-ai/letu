import { Form, Input, InputNumber, Modal, TreeSelect, Alert } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState, useRef, useCallback } from 'react';
import {
    addOrganizationUnit,
    excludeOrganizationSubtree,
    ORGANIZATION_UNIT_CATEGORY_DICT,
    ORGANIZATION_UNIT_TYPE_DICT,
    type OrganizationUnitCreateOrUpdateInput,
    type OrganizationUnitListOutput,
    type OrganizationUnitTreeNode,
    updateOrganizationUnit,
} from './-service';
import useApp from 'antd/es/app/useApp';
import DataDictionarySelect from '@/components/DataDictionarySelect';
import DataDictionaryDisplay from '@/components/DataDictionaryDisplay';
import RegionSelect, { type IRegionSelectValue } from '@/components/RegionSelect';
import MapView, { type IMapLocation, type IAddressInfo } from '@/components/amap/MapView';
import { parseLocationString, getAmapEnabled } from '@/components/amap/service';
import { getRegionByCode } from '@/pages/admin/regions/-service';
import { useAsyncEffect } from 'ahooks';

interface ModalProps {
    refresh?: () => void;
    tree: OrganizationUnitTreeNode[];
}

export interface OrganizationUnitModalRef {
    openModal: (row?: OrganizationUnitListOutput, defaultParentId?: string, category?: string) => void;
}

const OrganizationUnitForm = forwardRef<OrganizationUnitModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm<OrganizationUnitCreateOrUpdateInput>();
    const [row, setRow] = useState<OrganizationUnitListOutput | null>();
    const [treeData, setTreeData] = useState<OrganizationUnitTreeNode[]>([]);
    const { message } = useApp();

    // 检查高德地图是否启用
    const [amapEnabled, setAmapEnabled] = useState<boolean>(false);
    const [amapLoading, setAmapLoading] = useState<boolean>(true);

    useAsyncEffect(async () => {
        try {
            setAmapLoading(true);
            const enabled = await getAmapEnabled();
            setAmapEnabled(enabled);
        } catch (error) {
            console.error('获取高德地图启用状态失败:', error);
            setAmapEnabled(false);
        } finally {
            setAmapLoading(false);
        }
    }, []);

    // 地图相关状态
    const [mapCenter, setMapCenter] = useState<IMapLocation | undefined>();
    const [cityLimit, setCityLimit] = useState<string>("");
    const mapRef = useRef<AMap.Map | null>(null);

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    useEffect(() => {
        if (!isOpenModal) return;
        let tree = props.tree;
        if (row?.id) {
            tree = excludeOrganizationSubtree(tree, row.id);
        }
        setTreeData(tree);
    }, [isOpenModal, row, props.tree]);

    // 不再从服务端获取树，直接使用来自列表页的树

    const openModal = async (r?: OrganizationUnitListOutput, defaultParentId?: string, category: string = '') => {
        setIsOpenModal(true);
        if (r) {
            // 编辑模式：使用记录本身的分类
            setRow(r);
            form.setFieldsValue({
                name: r.name,
                sort: r.sort,
                parentId: r.parentId ?? undefined,
                category: r.category,
                type: r.type,
                regionCode: r.regionCode,
                streetName: r.streetName,
                address: r.address,
                contactPerson: r.contactPerson,
                contactPhone: r.contactPhone,
                longitude: r.longitude,
                latitude: r.latitude,
            });

            // 设置地图中心点
            if (r.longitude && r.latitude) {
                setMapCenter({ lng: Number(r.longitude), lat: Number(r.latitude) });
            } else {
                setMapCenter(undefined);
            }
            setCityLimit("");
        } else {
            // 新增模式：使用传入的分类，默认为空字符串
            setRow(null);
            form.resetFields();
            // 先设置 category，确保表单初始化时就有值
            form.setFieldsValue({
                category: category ?? '',
                sort: 1,
                ...(defaultParentId ? { parentId: defaultParentId } : {}),
            });
            setMapCenter(undefined);
            setCityLimit("");
        }
    };

    const onCancel = () => {
        form.resetFields();
        setIsOpenModal(false);
    };

    const onOk = () => {
        form.submit();
    };

    const handleSuccess = (successMessage: string) => {
        message.success(successMessage);
        setIsOpenModal(false);
        form.resetFields();
        props?.refresh?.();
    };

    const handleTypeChange = (value: string | undefined) => {
        form.setFieldValue('type', value || undefined);
    };

    // 处理行政区划选择每一步的变化 - 更新地图中心
    const handleRegionStepChange = useCallback(async (step: {
        level: 'province' | 'city' | 'district' | 'street';
        code?: string;
        name?: string;
    }) => {
        if (step.code) {
            try {
                const regionInfo = await getRegionByCode(step.code);
                if (regionInfo) {
                    // 更新城市限制
                    if (step.level === 'city' || step.level === 'province') {
                        const cityName = regionInfo.cityName || regionInfo.name;
                        setCityLimit(cityName);
                    }

                    // 更新地图中心和缩放级别
                    if (regionInfo.center) {
                        const center = parseLocationString(regionInfo.center);
                        setMapCenter(center);

                        // 根据级别设置不同的缩放级别
                        const zoomLevel = {
                            'province': 8,
                            'city': 11,
                            'district': 13,
                            'street': 15
                        }[step.level];
                        mapRef.current?.setZoomAndCenter(zoomLevel, [center.lng, center.lat]);
                    }
                }
            } catch (error) {
                console.error("获取区域信息失败:", error);
            }
        }
    }, []);

    // 处理行政区划选择变化
    const handleRegionChange = useCallback((regionValue: IRegionSelectValue | undefined) => {
        if (regionValue?.code) {
            form.setFieldsValue({
                regionCode: regionValue.code,
                streetName: regionValue.street || undefined,
            });
        } else {
            form.setFieldsValue({
                regionCode: undefined,
                streetName: undefined,
            });
            setCityLimit("");
            setMapCenter(undefined);
        }
    }, [form]);

    // 处理地图选择（点击搜索结果或地图点击）
    const handleMapSelect = useCallback((location: IMapLocation, addressInfo: IAddressInfo) => {
        // 更新表单字段
        form.setFieldsValue({
            regionCode: addressInfo.adCode,
            streetName: addressInfo.township || undefined,
            address: addressInfo.address,
            longitude: Number(location.lng.toFixed(6)),
            latitude: Number(location.lat.toFixed(6)),
        });

        // 更新地图中心
        setMapCenter(location);
    }, [form]);

    const onFinish = async (values: OrganizationUnitCreateOrUpdateInput) => {
        if (row?.id) {
            await updateOrganizationUnit(row.id, values);
            handleSuccess('编辑成功');
        } else {
            await addOrganizationUnit(values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            className="top-10"
            width={600}
            title={<><span>{row?.id ? '编辑机构' : '新增机构'} - </span><DataDictionaryDisplay
                emptyText='默认'
                dictName={ORGANIZATION_UNIT_CATEGORY_DICT}
                value={form.getFieldValue('category')}
            /></>}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
            destroyOnHidden
        >
            <Form<OrganizationUnitCreateOrUpdateInput>
                name="wrap"
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
                layout="vertical"
            >
                <Form.Item name="category" hidden>
                    <Input type="hidden" />
                </Form.Item>
                <Form.Item label="上级机构" name="parentId">
                    <TreeSelect
                        showSearch
                        style={{ width: '100%' }}
                        styles={{
                            popup: {
                                root: { maxHeight: 400, overflow: 'auto' },
                            },
                        }}
                        placeholder="请选择上级机构"
                        allowClear
                        treeDefaultExpandAll
                        treeData={treeData}
                        fieldNames={{
                            label: 'name',
                            value: 'id',
                            children: 'children',
                        }}
                        filterTreeNode={(input, node: any) =>
                            (node?.name as string)?.toLowerCase().includes((input as string).toLowerCase())}
                    />
                </Form.Item>
                <Form.Item label="机构名称" name="name" rules={[{ required: true }, { max: 64 }]}>
                    <Input placeholder="请输入机构名称" />
                </Form.Item>
                <Form.Item label="显示顺序" name="sort">
                    <InputNumber min={1} max={999} placeholder="数值越小越靠前" style={{ width: '100%' }} />
                </Form.Item>

                <Form.Item label="类型" name="type">
                    <DataDictionarySelect
                        dictName={ORGANIZATION_UNIT_TYPE_DICT}
                        placeholder="请选择类型"
                        value={form.getFieldValue('type')}
                        onChange={handleTypeChange}
                    />
                </Form.Item>
                <Form.Item label="所属行政区域" className='mb-0'>
                    <Form.Item
                        name="regionCode"
                        noStyle
                        rules={[{ required: true, message: "请选择所属行政区域" }]}
                    >
                        <Input className="hidden" />
                    </Form.Item>
                    <Form.Item name="streetName" noStyle>
                        <Input className="hidden" />
                    </Form.Item>
                    <Form.Item shouldUpdate={(prevValues, currentValues) =>
                        prevValues.regionCode !== currentValues.regionCode ||
                        prevValues.streetName !== currentValues.streetName
                    }>
                        {() => (
                            <RegionSelect
                                value={form.getFieldValue('regionCode') ? {
                                    code: form.getFieldValue('regionCode'),
                                    street: form.getFieldValue('streetName')
                                } : undefined}
                                onChange={handleRegionChange}
                                onStepChange={handleRegionStepChange}
                                showStreet={true}
                                placeholder="请选择行政区划"
                            />
                        )}
                    </Form.Item>
                </Form.Item>
                <Form.Item
                    label="地址"
                    name="address"
                    rules={[{ max: 256 }]}
                >
                    <Input placeholder="请输入详细地址" maxLength={256} />
                </Form.Item>
                <div className="grid grid-cols-2 gap-4">
                    <Form.Item label="经度" name="longitude">
                        <InputNumber
                            min={-180}
                            max={180}
                            precision={6}
                            placeholder="经度"
                            className="w-full"
                        />
                    </Form.Item>
                    <Form.Item label="纬度" name="latitude">
                        <InputNumber
                            min={-90}
                            max={90}
                            precision={6}
                            placeholder="纬度"
                            className="w-full"
                        />
                    </Form.Item>
                </div>

                {amapEnabled && (
                    <Form.Item label="地图选择位置">
                        <div className="h-96 border border-gray-200 rounded">
                            <MapView
                                defaultCenter={mapCenter}
                                showSearch={true}
                                searchCity={cityLimit}
                                onSelect={handleMapSelect}
                                onReady={(map) => {
                                    mapRef.current = map;
                                }}
                            />
                        </div>
                        <div className="mt-2 text-gray-500 text-sm">
                            点击地图选择位置，将自动填充行政区域、街道、地址和经纬度
                        </div>
                    </Form.Item>
                )}
                <Form.Item label="联系人" name="contactPerson">
                    <Input placeholder="请输入联系人" maxLength={64} />
                </Form.Item>
                <Form.Item label="联系电话" name="contactPhone">
                    <Input placeholder="请输入联系电话" maxLength={64} />
                </Form.Item>
            </Form>
        </Modal>
    );

});
export default OrganizationUnitForm;
