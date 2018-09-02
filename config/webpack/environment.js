const {environment} = require('@rails/webpacker');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const vue = require('./loaders/vue');

environment.loaders.append('vue', vue);
environment.loaders.append('pug', {
  test: /\.pug$/,
  use: 'pug-plain-loader'
});
environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin());
environment.config.merge({
  resolve: {
    alias: {
      vue: 'vue/dist/vue.common.js',
      vuex: 'vuex/dist/vuex.common.js'
    }
  }
});
module.exports = environment;