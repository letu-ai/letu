import tinycolor from "tinycolor2";

/**
 * 将颜色固定为指定亮度
 * @param {string} color - 原始颜色（支持hex、rgb、hsl等格式）
 * @param {number} targetLightness - 目标亮度（0-1之间的小数）
 * @returns {string} 处理后的颜色（hex格式）
 */
function fixedLightColor(color: string, targetLightness: number) {
    // 验证输入颜色是否有效
    const c = tinycolor(color);
    if (!c.isValid()) {
        throw new Error('无效的颜色值，请检查输入格式');
    }

    // 验证亮度值范围
    if (targetLightness < 0 || targetLightness > 1) {
        throw new Error('亮度值必须在0-1之间');
    }

    // 获取当前颜色的HSL值
    const hsl = c.toHsl();

    // 创建新颜色，保持色相和饱和度，只改变亮度
    return tinycolor({
        h: hsl.h,
        s: hsl.s,
        l: targetLightness,
        a: hsl.a
    }).toHexString();
}

export { fixedLightColor };