import React, { useEffect, useState } from "react";
import { Spin } from "antd";
import useDictionaryStore from "@/components/DataDictionarySelect/dictionaryStore";

interface IDataDictionaryDisplayProps {
    /** 字典名称 */
    dictName: string;
    /** 字典值（支持数字或字符串） */
    value?: string | number | null;
    /** 空值时的显示文本，默认为"未设置" */
    emptyText?: string;
    /** 自定义类名 */
    className?: string;
    /** 加载中时的显示文本，默认为"加载中..." */
    loadingText?: string;
}

/**
 * 数据字典显示组件
 * 用于在表单中只读显示数据字典的标签值
 */
const DataDictionaryDisplay: React.FC<IDataDictionaryDisplayProps> = ({
    dictName,
    value,
    emptyText = "未设置",
    className,
    loadingText = "加载中...",
}) => {
    const [label, setLabel] = useState<string>("");
    const [loading, setLoading] = useState<boolean>(false);
    const getDictionary = useDictionaryStore(state => state.getDictionary);

    useEffect(() => {
        const loadLabel = async () => {
            // 如果 value 为空，直接显示空值文本
            if (value === undefined || value === null || value === "") {
                setLabel(emptyText);
                return;
            }

            // 如果 dictName 为空，直接显示 value
            if (!dictName) {
                setLabel(String(value));
                return;
            }

            setLoading(true);
            try {
                const options = await getDictionary(dictName);
                // 统一将 value 转换为字符串进行比较
                const valueStr = String(value);
                const option = options.find(opt => opt.value === valueStr);
                setLabel(option?.label || emptyText);
            } catch (error) {
                console.error(`获取字典标签失败 [${dictName}]:`, error);
                setLabel(emptyText);
            } finally {
                setLoading(false);
            }
        };

        loadLabel();
    }, [dictName, value, emptyText, getDictionary]);

    if (loading) {
        return (
            <span className={className}>
                <Spin size="small" style={{ marginRight: 4 }} />
                {loadingText}
            </span>
        );
    }

    return <span className={className}>{label}</span>;
};

export default DataDictionaryDisplay;

