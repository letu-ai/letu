import React, { useState, useEffect, useRef, useMemo } from "react";
import { AutoComplete, Input, Empty, Spin } from "antd";
import { SearchOutlined, EnvironmentOutlined, CloseCircleOutlined } from "@ant-design/icons";
import { useDebounceFn } from "ahooks";
import { searchAddress } from "./service";
import type { IAddressPickerValue, IAmapPoi, IAddressPickerProps } from "./service";

const AddressPicker: React.FC<IAddressPickerProps> = ({
    value,
    onChange,
    placeholder = "请输入地址关键字搜索",
    disabled = false,
    allowClear = true,
    className = "",
    city,
}) => {
    const [inputValue, setInputValue] = useState("");
    const [searchResults, setSearchResults] = useState<IAmapPoi[]>([]);
    const [searching, setSearching] = useState(false);
    const [open, setOpen] = useState(false);

    // 用于标记是否是程序设置的值（避免触发搜索）
    const isProgrammaticChange = useRef(false);
    // 用于标记是否选中了搜索结果
    const isSelecting = useRef(false);

    // 将IAmapPoi转换为IAddressPickerValue
    const convertPoiToValue = (poi: IAmapPoi): IAddressPickerValue => {
        return {
            name: poi.name,
            address: poi.address || poi.name,
            location: poi.location,
            province: poi.provinceName,
            city: poi.cityName,
            district: poi.districtName,
            adCode: poi.adCode,
        };
    };

    // 搜索函数
    const handleSearch = async (keyword: string) => {
        if (!keyword || keyword.trim().length < 2) {
            setSearchResults([]);
            setOpen(false);
            return;
        }

        setSearching(true);
        setOpen(true);

        try {
            const results = await searchAddress(keyword, city);
            setSearchResults(results || []);
        } catch (error) {
            console.error("搜索地址失败:", error);
            setSearchResults([]);
        } finally {
            setSearching(false);
        }
    };

    // 防抖搜索
    const { run: debouncedSearch } = useDebounceFn(
        (keyword: string) => {
            if (!isProgrammaticChange.current && !isSelecting.current) {
                handleSearch(keyword);
            }
            isProgrammaticChange.current = false;
            isSelecting.current = false;
        },
        { wait: 500 }
    );

    // 处理输入变化
    const handleInputChange = (value: string) => {
        setInputValue(value);

        if (!value) {
            setSearchResults([]);
            setOpen(false);
            if (allowClear && onChange) {
                onChange(undefined);
            }
        } else {
            debouncedSearch(value);
        }
    };

    // 处理选择搜索结果
    const handleSelect = (selectedValue: string, option: any) => {
        const poi = option.poi as IAmapPoi;
        if (poi) {
            isSelecting.current = true;
            const addressValue = convertPoiToValue(poi);

            // 设置显示文本
            const displayText = poi.name || poi.address;
            setInputValue(displayText);

            // 触发onChange
            if (onChange) {
                onChange(addressValue);
            }

            setOpen(false);
            setSearchResults([]);
        }
    };

    // 处理清除
    const handleClear = () => {
        setInputValue("");
        setSearchResults([]);
        setOpen(false);
        if (onChange) {
            onChange(undefined);
        }
    };

    // 处理value变化（数据回填）
    useEffect(() => {
        if (value) {
            isProgrammaticChange.current = true;
            setInputValue(value.name || value.address || "");
        } else {
            // 如果value为空，清空输入框
            isProgrammaticChange.current = true;
            setInputValue("");
        }
    }, [value]);

    // 渲染搜索结果选项
    const options = useMemo(() => {
        return searchResults.map((poi) => ({
            value: poi.id,
            poi: poi,
            label: (
                <div className="py-2">
                    <div className="flex items-start gap-2">
                        <EnvironmentOutlined className="text-blue-500 text-base mt-0.5" />
                        <div className="flex-1 overflow-hidden">
                            <div className="text-sm font-medium text-gray-800 truncate">{poi.name}</div>
                            <div className="text-xs text-gray-400 mt-1 truncate">
                                {poi.provinceName}
                                {poi.cityName && poi.cityName !== poi.provinceName && ` ${poi.cityName}`}
                                {poi.districtName && ` ${poi.districtName}`}
                                {poi.address && poi.address !== poi.name && ` ${poi.address}`}
                            </div>
                        </div>
                    </div>
                </div>
            ),
        }));
    }, [searchResults]);

    // 渲染空内容
    const notFoundContent = useMemo(() => {
        if (searching) {
            return (
                <div className="flex items-center justify-center gap-2 py-4 text-gray-400 text-sm">
                    <Spin size="small" />
                    <span>搜索中...</span>
                </div>
            );
        }

        if (inputValue && inputValue.length >= 2 && searchResults.length === 0) {
            return (
                <Empty
                    image={Empty.PRESENTED_IMAGE_SIMPLE}
                    description="未找到相关地址"
                />
            );
        }

        return null;
    }, [searching, inputValue, searchResults.length]);

    return (
        <AutoComplete
            className={`w-full ${className}`}
            value={inputValue}
            options={options}
            onChange={handleInputChange}
            onSelect={handleSelect}
            open={open}
            onOpenChange={setOpen}
            disabled={disabled}
            notFoundContent={notFoundContent}
            popupMatchSelectWidth={false}
            styles={{
                popup: {
                    root: { maxHeight: 400, overflow: 'auto' }
                }
            }}
        >
            <Input
                placeholder={placeholder}
                prefix={<SearchOutlined />}
                suffix={
                    allowClear && inputValue ? (
                        <CloseCircleOutlined
                            className="text-gray-400 text-xs cursor-pointer hover:text-gray-600 transition-colors"
                            onClick={handleClear}
                        />
                    ) : null
                }
                disabled={disabled}
            />
        </AutoComplete>
    );
};

export default AddressPicker;