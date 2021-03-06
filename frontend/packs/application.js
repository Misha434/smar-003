// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
// frontend/packs/application.js
import "init";

import "src/users/users";

import "src/pages/pages";

import "src/products/products";

import "src/reviews/reviews";

import "src/brands/brands";

import JQuery from "jquery";

window.$ = window.JQuery = JQuery; // eslint-disable-line

import "bootstrap"; // eslint-disable-line

import "@fortawesome/fontawesome-free/js/all"; // eslint-disable-line

import "../src/application.scss"; // eslint-disable-line

require("@rails/ujs").start();
require("@rails/activestorage").start();
// require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context("../images", true); // eslint-disable-line
const imagePath = name => images(name, true); // eslint-disable-line
