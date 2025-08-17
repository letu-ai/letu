export const StringValueTypes = {
    FreeText: "FreeTextStringValueType",
    Selection: "SelectionStringValueType",
    Toggle: "ToggleStringValueType",
} as const;

export type StringValueTypes = typeof StringValueTypes[keyof typeof StringValueTypes];

export interface IValidator {
    name: string;
    properties: Record<string, any>;
}

export interface IStringValueType {
    itemSource?: ISelectionStringValueItemSource
    name: StringValueTypes
    properties: Record<string, any>
    validator: IValidator
}

export interface ISelectionStringValueItemSource {
    items: ISelectionStringValueItem[]
}

export interface ILocalizableStringInfo {
    resourceName: string,
    name: string
}

export interface ISelectionStringValueItem {
    value: string;
    displayText: ILocalizableStringInfo;
}

