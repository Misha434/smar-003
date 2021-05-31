const { environment } = require("@rails/webpacker");

const webpack = require("webpack"); // eslint-disable-line

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    jquery: "jquery",
    Popper: ["popper.js", "default"]
  })
);

module.exports = environment;
