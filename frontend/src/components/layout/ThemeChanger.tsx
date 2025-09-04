import { ColorPicker } from 'antd';
import useThemeStore from '@/application/themeStore';


const ThemeChanger = () => {
    const setThemeColor = useThemeStore(state => state.setThemeColor);
    const colorPrimary = useThemeStore(state => state.theme.token?.colorPrimary);
    const changePrimaryColor = (color: string) => {
        setThemeColor(color);
    };

    return (
        <div className="flex gap-2 ">
            <ColorPicker defaultValue={`${colorPrimary}`} onChange={(value) => changePrimaryColor(value.toHexString())} />
        </div>
    )

}

export default ThemeChanger;