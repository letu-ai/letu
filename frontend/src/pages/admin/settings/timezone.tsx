import { Form, Select, Button, Typography, message, Spin } from 'antd';
import type { DefaultOptionType } from 'antd/es/select';
import { fetchTimeZones, fetchTimeZoneSettings, type ITimeZone, updateTimeZoneSettings } from './service';
import { useState, useEffect } from 'react';

const { Title } = Typography;

function TimeZoneSettings() {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [pageLoading, setPageLoading] = useState(true);
    const [timeZoneOptions, setTimeZoneOptions] = useState<DefaultOptionType[]>([]);
    const [currentTimeZone, setCurrentTimeZone] = useState<string>('');

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [timeZonesData, settingsData] = await Promise.all([
                    fetchTimeZones(),
                    fetchTimeZoneSettings()
                ]);

                // 将服务端数据转换为Select组件所需的格式
                const options: DefaultOptionType[] = timeZonesData.map((tz: ITimeZone) => ({
                    label: tz.name,
                    value: tz.value
                }));

                setTimeZoneOptions(options);
                setCurrentTimeZone(settingsData);
                form.setFieldsValue({ timeZone: settingsData });
            } catch (error) {
                message.error('获取时区设置失败');
            } finally {
                setPageLoading(false);
            }
        };
        fetchData();
    }, [form]);

    const handleSubmit = async (values: { timeZone: string }) => {
        setLoading(true);
        try {
            await updateTimeZoneSettings(values.timeZone);
            message.success('更新时区设置成功');
        } catch (error) {
            message.error('更新时区设置失败');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={{ maxWidth: 800 }}>
            <Spin spinning={pageLoading} tip="加载中...">
                <Title level={3} style={{ textAlign: 'center', marginBottom: 32 }}>
                    时区设置
                </Title>
                <Form
                    form={form}
                    layout="vertical"
                    onFinish={handleSubmit}
                    initialValues={{ timeZone: currentTimeZone }}
                >
                    <Form.Item
                        name="timeZone"
                        label="时区"
                        help="此设置用于应用程序范围或基于租户。"
                        rules={[{ required: true, message: '请选择时区' }]}
                    >
                        <Select
                            placeholder="请选择时区"
                            showSearch
                            filterOption={(input, option) =>
                                String(option?.label ?? '').toLowerCase().includes(input.toLowerCase())
                            }
                            options={timeZoneOptions}
                        />
                    </Form.Item>

                    <div style={{ textAlign: 'center', marginTop: 24 }}>
                        <Button type="primary" htmlType="submit" loading={loading}>
                            保存
                        </Button>
                    </div>
                </Form>
            </Spin>
        </div>
    );
}

export default TimeZoneSettings;
