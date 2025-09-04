import { create } from "zustand";
import type { SelectOption } from "@/types/api";
import { getDictionaryOptions, getDictionaryOptionsBatch } from "./-service";

interface DictionaryStore {
  cache: Map<string, SelectOption[]>;
  loading: Map<string, boolean>;
  
  getDictionary: (name: string) => Promise<SelectOption[]>;
  getDictionaries: (names: string[]) => Promise<Record<string, SelectOption[]>>;
  refreshDictionary: (name: string) => Promise<SelectOption[]>;
  clearCache: () => void;
}

const useDictionaryStore = create<DictionaryStore>((set, get) => ({
  cache: new Map(),
  loading: new Map(),

  getDictionary: async (name: string) => {
    const { cache, loading } = get();
    
    // 如果正在加载，等待加载完成
    if (loading.get(name)) {
      return new Promise((resolve) => {
        const checkInterval = setInterval(() => {
          const { cache, loading } = get();
          if (!loading.get(name)) {
            clearInterval(checkInterval);
            resolve(cache.get(name) || []);
          }
        }, 100);
      });
    }

    // 如果有缓存，直接返回
    if (cache.has(name)) {
      return cache.get(name)!;
    }

    // 设置加载状态
    set((state) => ({
      loading: new Map(state.loading).set(name, true)
    }));

    try {
      // 从服务器获取数据
      const data = await getDictionaryOptions(name);
      
      // 更新缓存
      set((state) => ({
        cache: new Map(state.cache).set(name, data),
        loading: new Map(state.loading).set(name, false)
      }));
      
      return data;
    } catch (error) {
      // 加载失败，清除加载状态
      set((state) => ({
        loading: new Map(state.loading).set(name, false)
      }));
      throw error;
    }
  },

  getDictionaries: async (names: string[]) => {
    const { cache } = get();
    const result: Record<string, SelectOption[]> = {};
    const uncachedNames: string[] = [];

    // 分离已缓存和未缓存的字典
    for (const name of names) {
      if (cache.has(name)) {
        result[name] = cache.get(name)!;
      } else {
        uncachedNames.push(name);
      }
    }

    // 如果都有缓存，直接返回
    if (uncachedNames.length === 0) {
      return result;
    }

    // 批量获取未缓存的字典
    try {
      const batchData = await getDictionaryOptionsBatch(uncachedNames);
      
      // 更新缓存并合并结果
      set((state) => {
        const newCache = new Map(state.cache);
        for (const [name, options] of Object.entries(batchData)) {
          newCache.set(name, options);
          result[name] = options;
        }
        return { cache: newCache };
      });

      return result;
    } catch (error) {
      console.error("Failed to fetch dictionaries:", error);
      // 返回部分结果（已缓存的）
      return result;
    }
  },

  refreshDictionary: async (name: string) => {
    // 设置加载状态
    set((state) => ({
      loading: new Map(state.loading).set(name, true)
    }));

    try {
      // 从服务器获取最新数据
      const data = await getDictionaryOptions(name);
      
      // 更新缓存
      set((state) => ({
        cache: new Map(state.cache).set(name, data),
        loading: new Map(state.loading).set(name, false)
      }));
      
      return data;
    } catch (error) {
      // 加载失败，清除加载状态
      set((state) => ({
        loading: new Map(state.loading).set(name, false)
      }));
      throw error;
    }
  },

  clearCache: () => {
    set({ cache: new Map(), loading: new Map() });
  }
}));

export default useDictionaryStore;