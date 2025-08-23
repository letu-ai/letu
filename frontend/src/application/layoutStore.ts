import { create } from 'zustand';

export type SizeType = 'small' | 'middle' | 'large';

export function isSizeType(key: string): key is SizeType {
    return key === 'small' || key === 'middle' || key === 'large'
}

export interface ILayoutLayoutStore {
    size: SizeType
    setSize: (size: SizeType) => void

    collapsed: boolean
    toggleCollapsed: () => void
}

const useLayoutStore = create<ILayoutLayoutStore>((set) => ({
    // 默认主题
    size: 'middle',
    setSize: size => set({ size }),

    collapsed: false,
    toggleCollapsed: () => set(state => ({ collapsed: !state.collapsed }))
}));

export default useLayoutStore;