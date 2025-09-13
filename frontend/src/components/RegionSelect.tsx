import React, { useEffect, useState } from "react";
import { Select, Space } from "antd";
import { useQuery } from "@tanstack/react-query";
import { getRegionChildrenByCode, getRegionPathByCodes, getStreets } from "@/pages/admin/regions/-service";

interface IRegionSelectValue {
    code?: string;
    street?: string;
}

interface IRegionSelectProps {
    value?: IRegionSelectValue;
    onChange?: (value: IRegionSelectValue | undefined) => void;
    placeholder?: string;
    disabled?: boolean;
    allowClear?: boolean;
    className?: string;
    showStreet?: boolean;
}

export type { IRegionSelectValue };

const RegionSelect: React.FC<IRegionSelectProps> = ({
    value,
    onChange,
    disabled = false,
    allowClear = true,
    className,
    showStreet = false
}) => {
    const [provinceCode, setProvinceCode] = useState<string | undefined>();
    const [cityCode, setCityCode] = useState<string | undefined>();
    const [districtCode, setDistrictCode] = useState<string | undefined>();
    const [streetName, setStreetName] = useState<string | undefined>();
    // 默认显示所有级别，只有明确知道没有下级时才隐藏
    const [showCity, setShowCity] = useState(true);
    const [showDistrict, setShowDistrict] = useState(true);
    const [showStreetInternal, setShowStreetInternal] = useState(true);

    // 加载省份列表
    const { data: provinces, isLoading: provincesLoading } = useQuery({
        queryKey: ["regions", "provinces"],
        queryFn: () => getRegionChildrenByCode(),
        staleTime: 60 * 60 * 1000,
        gcTime: 2 * 60 * 60 * 1000,
    });

    // 加载市列表
    const { data: cities, isLoading: citiesLoading } = useQuery({
        queryKey: ["regions", "cities", provinceCode],
        queryFn: () => getRegionChildrenByCode(provinceCode),
        enabled: !!provinceCode,
        staleTime: 60 * 60 * 1000,
        gcTime: 2 * 60 * 60 * 1000,
    });

    // 加载区县列表
    const { data: districts, isLoading: districtsLoading } = useQuery({
        queryKey: ["regions", "districts", cityCode],
        queryFn: () => getRegionChildrenByCode(cityCode),
        enabled: !!cityCode && showDistrict,
        staleTime: 60 * 60 * 1000,
        gcTime: 2 * 60 * 60 * 1000,
    });

    // 加载街道列表
    const { data: streets, isLoading: streetsLoading } = useQuery({
        queryKey: ["regions", "streets", districtCode || cityCode],
        queryFn: async () => {
            const regionCode = districtCode || cityCode;
            if (!regionCode) return [];
            const streetNames = await getStreets(regionCode);
            return streetNames.map(name => ({ label: name, value: name }));
        },
        enabled: showStreet && !!(districtCode || (cityCode && !showDistrict)) && showStreetInternal,
        staleTime: 60 * 60 * 1000,
        gcTime: 2 * 60 * 60 * 1000,
    });

    // 根据value回填数据
    useEffect(() => {
        if (value?.code) {
            // 根据value获取完整路径并回填
            getRegionPathByCodes(value.code).then(path => {
                if (path && path.length > 0) {
                    // 从路径中提取各级code
                    const codes = path.map(r => r.code);
                    if (codes.length > 0) setProvinceCode(codes[0]);
                    if (codes.length > 1) setCityCode(codes[1]);
                    if (codes.length > 2) setDistrictCode(codes[2]);

                    // 根据路径设置显示控制
                    // 只有明确知道没有下级时才隐藏
                    if (path.length > 0) {
                        const provinceData = path[0];
                        setShowCity(provinceData.nextLevel !== 0);
                    }
                    if (path.length > 1) {
                        const cityData = path[1];
                        // NextLevel: 0=无下级，3=下级是区县，4=下级是街道
                        setShowDistrict(cityData.nextLevel !== 0 && cityData.nextLevel !== 4);
                        setShowStreetInternal(cityData.nextLevel === 4 || (path.length > 2 && path[2].nextLevel !== 0));
                    }
                }
            });
        } else {
            // value 为空时清空所有选择
            setProvinceCode(undefined);
            setCityCode(undefined);
            setDistrictCode(undefined);
            setStreetName(undefined);
            setShowCity(true);
            setShowDistrict(true);
            setShowStreetInternal(true);
        }

        // 设置街道值（包括空字符串的情况）
        if (value?.code) {
            setStreetName(value.street);
        }
    }, [value?.code, value?.street]);

    // 处理省份变化
    const handleProvinceChange = (code: string | undefined) => {
        setProvinceCode(code);
        setCityCode(undefined);
        setDistrictCode(undefined);
        setStreetName(undefined);

        if (code) {
            const selectedProvince = provinces?.find(p => p.code === code);
            if (selectedProvince) {
                // 只有明确没有下级时才隐藏
                setShowCity(selectedProvince.nextLevel !== 0);
                // 省份选择后，重置区县和街道的显示状态为默认显示
                setShowDistrict(true);
                setShowStreetInternal(true);

                // 如果省份是叶节点，直接返回
                if (selectedProvince.nextLevel === 0) {
                    onChange?.({ code });
                } else {
                    // 不是叶节点，清空表单值
                    onChange?.(undefined);
                }
            }
        } else {
            // 清空选择时，恢复默认显示所有级别
            setShowCity(true);
            setShowDistrict(true);
            setShowStreetInternal(true);
            onChange?.(undefined);
        }
    };

    // 处理市变化
    const handleCityChange = (code: string | undefined) => {
        setCityCode(code);
        setDistrictCode(undefined);
        setStreetName(undefined);

        if (code) {
            const selectedCity = cities?.find(c => c.code === code);
            if (selectedCity) {
                // NextLevel: 0=无下级，3=下级是区县，4=下级是街道（直辖市）
                // 只有当明确是直辖市（NextLevel=4）时才隐藏区县
                setShowDistrict(selectedCity.nextLevel !== 0 && selectedCity.nextLevel !== 4);
                // 默认显示街道，除非没有下级
                setShowStreetInternal(selectedCity.nextLevel !== 0);

                // 如果市是叶节点，直接返回市code
                // 叶节点条件：nextLevel === 0 或者 nextLevel === 4 且不显示街道
                if (selectedCity.nextLevel === 0 || (selectedCity.nextLevel === 4 && !showStreet)) {
                    onChange?.({ code, street: showStreet ? "" : undefined });
                } else if (selectedCity.nextLevel === 4 && showStreet && !showStreetInternal) {
                    // 直辖市有街道权限但当前区域无街道级别
                    onChange?.({ code, street: "" });
                } else {
                    // 不是叶节点，清空表单值
                    onChange?.(undefined);
                }
            }
        } else {
            // 清空选择时，恢复默认显示区县和街道
            setShowDistrict(true);
            setShowStreetInternal(true);
            onChange?.(undefined);
        }
    };

    // 处理区县变化
    const handleDistrictChange = (code: string | undefined) => {
        setDistrictCode(code);
        setStreetName(undefined);

        if (code) {
            const selectedDistrict = districts?.find(d => d.code === code);
            if (selectedDistrict) {
                // 只有明确没有下级时才隐藏街道
                setShowStreetInternal(selectedDistrict.nextLevel !== 0);

                // 如果区县是叶节点，直接返回
                // 叶节点条件：nextLevel === 0 或者有街道但不显示街道选择器
                if (selectedDistrict.nextLevel === 0 || (selectedDistrict.nextLevel !== 0 && !showStreet)) {
                    onChange?.({ code, street: showStreet ? "" : undefined });
                } else if (selectedDistrict.nextLevel !== 0 && showStreet && !showStreetInternal) {
                    // 有街道权限但当前区域无街道级别
                    onChange?.({ code, street: "" });
                } else {
                    // 不是叶节点且需要选择街道，清空表单值
                    onChange?.(undefined);
                }
            }
        } else {
            // 清空选择时，恢复默认显示街道
            setShowStreetInternal(true);
            onChange?.(undefined);
        }
    };

    // 处理街道变化
    const handleStreetChange = (street: string | undefined) => {
        setStreetName(street);
        const currentCode = districtCode || cityCode;
        if (street && currentCode) {
            onChange?.({ code: currentCode, street });
        } else {
            onChange?.(undefined);
        }
    };

    return (
        <Space.Compact className={className}>
            {/* 省份选择器 - 始终显示 */}
            <Select
                value={provinceCode || undefined}
                onChange={handleProvinceChange}
                placeholder="请选择省份"
                loading={provincesLoading}
                disabled={disabled}
                allowClear={allowClear}
                className="w-40"
                options={provinces?.map(p => ({
                    label: p.name,
                    value: p.code
                }))}
            />

            {/* 城市选择器 - 根据省份的 NextLevel 控制显示 */}
            {showCity && (
                <Select
                    value={cityCode || undefined}
                    onChange={handleCityChange}
                    placeholder="请选择城市"
                    loading={citiesLoading}
                    disabled={disabled || !provinceCode}
                    allowClear={allowClear}
                    className="w-40"
                    options={cities?.map(c => ({
                        label: c.name,
                        value: c.code
                    }))}
                />
            )}

            {/* 区县选择器 - 默认显示，只有直辖市时隐藏 */}
            {showDistrict && (
                <Select
                    value={districtCode || undefined}
                    onChange={handleDistrictChange}
                    placeholder="请选择区县"
                    loading={districtsLoading}
                    disabled={disabled || !cityCode}
                    allowClear={allowClear}
                    className="w-40"
                    options={districts?.map(d => ({
                        label: d.name,
                        value: d.code
                    }))}
                />
            )}

            {/* 街道选择器 - 根据showStreet属性和内部状态控制显示 */}
            {showStreet && showStreetInternal && (
                <Select
                    value={streetName || undefined}
                    onChange={handleStreetChange}
                    placeholder="请选择街道"
                    loading={streetsLoading}
                    disabled={disabled || (!showDistrict ? !cityCode : !districtCode)}
                    allowClear={allowClear}
                    className="w-40"
                    options={streets}
                />
            )}
        </Space.Compact>
    );
};

export default RegionSelect;