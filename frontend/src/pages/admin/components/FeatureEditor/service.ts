import httpClient from '@/utils/httpClient';
import { type IStringValueType } from "@/application/string-values";

export interface IFeatureProvider {
    name: string
    key?: string
}

export interface IFeatureGroup {
    name: string
    displayName: string
    features: IFeature[]
}

export interface IFeature {
    name: string
    displayName: string
    description?: string
    value: string
    valueType: IStringValueType
    depth: number
    provider: IFeatureProvider
    parentName?: string
}

export interface IFeatureUpdateInput {
    name: string
    value: string
}

export interface IFeaturesUpdateInput {
    features: IFeatureUpdateInput[]
}

export interface IGetFeatureListResult {
    groups: IFeatureGroup[]
}

export function fetchFeatureGroups(providerName: string, providerKey?: string): Promise<IGetFeatureListResult> {
    return httpClient.get<void, IGetFeatureListResult>("/api/admin/feature-management/features", {
        params: {
            providerName,
            providerKey
        }
    });
}

export function updateFeature(providerName: string, providerKey: string | undefined, data: IFeaturesUpdateInput): Promise<void> {
    return httpClient.put<IFeaturesUpdateInput, void>("/api/admin/feature-management/features", data, {
        params: {
            providerName,
            providerKey
        }
    });
}

export function deleteFeature(providerName: string, providerKey?: string): Promise<void> {
    return httpClient.delete<void, void>("/api/admin/feature-management/features", {
        params: {
            providerName,
            providerKey
        }
    });
}
