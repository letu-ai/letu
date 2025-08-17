import { configureStore } from "@reduxjs/toolkit";
import { combineReducers } from "redux";
import { persistStore, persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage"; // 使用默认的localStorage
import tabReducer from "./tabStore.ts";

/**
 * 一定要保留包含storage的reducer，否则报错；这是redux-persist带来影响
 */
const persistedReducer = combineReducers({
  tab: persistReducer(
      {
        key: "tab",
        storage: storage,
      },
      tabReducer
  ),
});

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({ serializableCheck: false }),
});

export const persistor = persistStore(store);
