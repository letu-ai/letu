import React, { useEffect, useState } from "react";
import { Select, Radio, Spin, type SelectProps } from "antd";
import { ReloadOutlined } from "@ant-design/icons";
import useDictionaryStore from "./dictionaryStore";
import type { SelectOption } from "@/types/api";

interface IDataDictionarySelectProps extends Omit<SelectProps, "options" | "loading"> {
    dictName: string;
    isPlainText?: boolean;
    valueType?: "select" | "radio";
    initialLabel?: string | null;
}

const DataDictionarySelect: React.FC<IDataDictionarySelectProps> = ({
    dictName,
    isPlainText,
    valueType = "select",
    initialLabel,
    value,
    placeholder = "请选择",
    allowClear = true,
    ...restProps
}) => {
    const [options, setOptions] = useState<SelectOption[]>([]);
    const [loading, setLoading] = useState(false);
    const [isRefreshing, setIsRefreshing] = useState(false);
    const getDictionary = useDictionaryStore(state => state.getDictionary);
    const refreshDictionary = useDictionaryStore(state => state.refreshDictionary);

    // 加载字典数据
    const loadDictionary = async () => {
        if (!dictName) return;
        
        setLoading(true);
        try {
            const data = await getDictionary(dictName);
            setOptions(data);
        } catch (error) {
            console.error(`Failed to load dictionary ${dictName}:`, error);
            setOptions([]);
        } finally {
            setLoading(false);
        }
    };

    // 刷新字典数据
    const handleRefresh = async (e: React.MouseEvent) => {
        e.stopPropagation();
        setIsRefreshing(true);
        try {
            const data = await refreshDictionary(dictName);
            setOptions(data);
        } catch (error) {
            console.error(`Failed to refresh dictionary ${dictName}:`, error);
        } finally {
            setIsRefreshing(false);
        }
    };

    useEffect(() => {
        loadDictionary();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [dictName]);

    // 纯文本显示模式
    if (isPlainText) {
        const displayText = options?.find((item) => item.value === value)?.label || value;
        return <span>{displayText}</span>;
    }

    // 处理初始值显示
    const displayOptions = options.length > 0 ? options : 
        (value && initialLabel ? [{ value, label: initialLabel }] : []);

    // Radio 模式
    if (valueType === "radio") {
        return (
            <Spin spinning={loading || isRefreshing}>
                <Radio.Group 
                    {...restProps}
                    options={displayOptions} 
                    value={value} 
                />
            </Spin>
        );
    }

    // Select 模式（默认）
    return (
        <Select
            placeholder={placeholder}
            allowClear={allowClear}
            {...restProps}
            options={displayOptions}
            value={value}
            loading={loading}
            notFoundContent={loading ? <Spin size="small" /> : "暂无数据"}
            popupRender={(menu) => (
                <div className="relative">
                    {menu}
                    {!loading && !isRefreshing && (
                        <button
                            onClick={handleRefresh}
                            className="absolute top-0 right-0 w-6 h-6 bg-white/80 hover:bg-gray-100 rounded-full shadow-sm transition-colors"
                            title="刷新字典"
                        >
                            <ReloadOutlined 
                                className={`text-xs text-gray-600 ${isRefreshing ? "animate-spin" : ""}`} 
                            />
                        </button>
                    )}
                </div>
            )}
        />
    );
};

export default DataDictionarySelect;