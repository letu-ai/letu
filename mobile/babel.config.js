module.exports = {
    presets: ['module:@react-native/babel-preset', 'nativewind/babel'],
    plugins: [
        '@babel/plugin-proposal-export-namespace-from',
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
