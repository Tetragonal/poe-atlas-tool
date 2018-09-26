/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import VueClipboards from 'vue-clipboards';

import App from '../app.vue'
import router from '../router.js'
import store from '../store.js'
import '../mixin.js'

Vue.use(VueClipboards);
Vue.use(BootstrapVue);

/* Initialize vue */
document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('app'));
  const app = new Vue({
    el,
    router,
    store,
    render: h => h(App)
  });
});