module.exports = function (api) {
    api.cache(true);
    return {
        presets: ['module:@react-native/babel-preset', 'nativewind/babel'],
        plugins: [
            '@babel/plugin-proposal-export-namespace-from',
            [
                'module:react-native-dotenv',
                {
                    moduleName: '@env',
                    path: '.env',
                    safe: false,
                    allowUndefined: true,
                },
            ],
            [
                'module-resolver',
                {
                    root: ['./'],
                    alias: {
                        '@': './src',
                    },
                },
            ],
        ],
    };
};
