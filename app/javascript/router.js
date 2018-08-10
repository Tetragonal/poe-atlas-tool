import Vue from 'vue'
import VueRouter from 'vue-router';

import Home from './components/pages/Home'
import AtlasParser from './components/pages/AtlasParser'

Vue.use(VueRouter);

const routes = [
  { path: '/home', component: Home },
  { path: '/parser', component: AtlasParser },
  { path: '*', redirect: '/home' }
];

export default new VueRouter({
  mode: 'history',
  routes
});