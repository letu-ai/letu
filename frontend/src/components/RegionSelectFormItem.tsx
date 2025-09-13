import React from "react";
import { Form, type FormItemProps } from "antd";
import RegionSelect, { type IRegionSelectValue } from "./RegionSelect";
import type { NamePath } from "antd/es/form/interface";

interface IRegionSelectFormItemProps extends Omit<FormItemProps, "name" | "children"> {
    name: NamePath;
    showStreet?: boolean;
    disabled?: boolean;
    allowClear?: boolean;
    placeholder?: string;
}

const RegionSelectFormItem: React.FC<IRegionSelectFormItemProps> = ({
    name,
    showStreet = false,
    disabled = false,
    allowClear = true,
    placeholder,
    label = "所在地区",
    required = false,
    rules = [],
    ...restProps
}) => {
    return (
        <Form.Item
            name={name}
            label={label}
            required={required}
            rules={[
                ...rules,
                {
                    validator: async (_, value: IRegionSelectValue | undefined) => {
                        // 必填校验
                        if (required && !value?.code) {
                            throw new Error(`请选择${label}`);
                        }

                        // 街道校验（仅在showStreet=true且required=true时）
                        if (required && showStreet && value?.code) {
                            // street为空字符串表示该区域无街道层级，直接通过
                            if (value.street === "") return;
                            // street为undefined或null表示有街道但未选择
                            if (value.street == null) {
                                throw new Error("请选择街道");
                            }
                        }
                    },
                },
            ]}
            {...restProps}
        >
            <RegionSelect
                showStreet={showStreet}
                disabled={disabled}
                allowClear={allowClear}
                placeholder={placeholder || `请选择${label}`}
            />
        </Form.Item>
    );
};

export default RegionSelectFormItem;
export type { IRegionSelectValue };