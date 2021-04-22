const WriteFilePlugin = require ('write-file-webpack-plugin');
const path = require ('path');

module.exports = {
	entry: "./build.hxml",
	output: {
		path: path.resolve (__dirname, "dist"),
		filename: "app.js",
	},
	plugins: [
		new WriteFilePlugin (),
	],
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, "node_modules/openfl/lib/openfl")
		}
	},
	module: {
		rules: [
			{ test: /\.hxml$/, loader: 'haxe-loader' }
		]
	}
};