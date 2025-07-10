import { createSlice } from '@reduxjs/toolkit';

export const themeSlice = createSlice({
  name: 'themeSettings',
  initialState: {
    collapsed: false,
    size: 'middle',
  },
  reducers: {
    toggleCollapsed: (state) => {
      state.collapsed = !state.collapsed;
    },
    setSize: (state, action) => {
      const sizeOptions = ['large', 'middle', 'small'];
      if (sizeOptions.some((h) => h === action.payload)) {
        state.size = action.payload;
      } else {
        console.error('全局尺寸设置错误');
      }
    },
  },
});

export default themeSlice.reducer;
export const { toggleCollapsed, setSize } = themeSlice.actions;

export const selectCollapsed = (state: { themeSettings: { collapsed: any } }) => state.themeSettings.collapsed;
export const selectSize = (state: { themeSettings: { size: any } }) => state.themeSettings.size;
