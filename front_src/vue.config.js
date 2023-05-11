// vue.config.js
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const plugins = []

if (process.env.NODE_ENV === "development") {
    plugins.push(new BundleAnalyzerPlugin())
}

module.exports = {
    productionSourceMap: false,
    publicPath: "./",
    lintOnSave: false,
    configureWebpack: {
        plugins,
        externals: {
            'vue': 'Vue',
            'element-ui': 'ElementUI',
        }
    }
}