import { theme, type ThemeConfig } from 'antd';
import { create } from 'zustand';

// 清爽紫色主题配置
const defaultTheme: ThemeConfig = {
    algorithm: theme.defaultAlgorithm,
    token: {
        colorPrimary: '#7E57C2',
        colorLink: '#7E57C2',
        colorSuccess: '#66BB6A',
        colorWarning: '#FFA726',
        colorError: '#FF7043',
        colorBgBase: '#FFFFFF',
        colorTextBase: '#4A4A4A',
        borderRadius: 4,
        fontSize: 14,
    },
    components: {
        Layout: {
            siderBg: '#FFFFFF',
            headerBg: '#FFFFFF',
        },
        Menu: {
            itemBg: '#FFFFFF',
            itemColor: '#4A4A4A',
            itemSelectedBg: '#EDE7F6',
            itemSelectedColor: '#7E57C2',
            itemHoverBg: '#F5F3FF',
            itemBorderRadius: 8,
        },
        Button: {
            // colorPrimary: '#7E57C2',
            colorPrimaryHover: '#9575CD',
            colorPrimaryActive: '#673AB7',
        },
        Table: {
            headerBg: '#F5F3FF',
            headerColor: '#4A4A4A',
            borderColor: '#EDE7F6',
        },
    },
};

interface IThemeStore {
    theme: ThemeConfig

    setTheme: (theme: ThemeConfig) => void
}

const useThemeStore = create<IThemeStore>(set => ({
    // 默认主题
    theme: defaultTheme,

    // 设置特定主题
    setTheme: theme => set({ theme }),
}));

export default useThemeStore;