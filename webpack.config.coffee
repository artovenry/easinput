_ = require "underscore"
path= require "path"
env= process.env.NODE_ENV
host= process.env.npm_config_host ? "localhost"
port= process.env.npm_config_port ? "8080"

Autoprefixer= require "autoprefixer"
VueLoaderPlugin= require "vue-loader/lib/plugin"

module.exports=
  devServer: {host, port}
  resolve:
    modules: [path.resolve("src"), "node_modules"]
    extensions:[".js", ".coffee"]
  module: rules: do ->
    babelLoader= loader: "babel-loader", options: presets: ["@babel/env"], plugins: ["transform-vue-jsx"]
    _.values
      JS:
        test: /\.js$/, use: [babelLoader], exclude: /node_modules/
      COFFEE:
        test: /\.coffee$/, use: [babelLoader, {loader: "coffee-loader"}]
      YAML:
        test: /\.ya?ml$/i, loader: "json-loader!yaml-loader"
      VUE:
        test: /\.vue$/, loader: "vue-loader"
      PUG:
        test: /\.pug$/, loader: "pug-plain-loader"
      CSS:
        test: /\.s?css$/, use: [
          {loader: "style-loader"}
          {loader: "css-loader", options: importLoaders: 2}
          {loader: "postcss-loader", options: {plugins: [Autoprefixer(grid: "no-autoplace")]}}
          {loader: "sass-loader"}
        ]
  plugins: _.values
    VUE: new VueLoaderPlugin
