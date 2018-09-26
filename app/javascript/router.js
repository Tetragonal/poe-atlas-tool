import Vue from 'vue'
import VueRouter from 'vue-router';

import Home from './components/pages/Home'
import AtlasParser from './components/pages/AtlasParser/AtlasParser'
import MapTrade from './components/pages/MapTrade/MapTrade'
import Progressions from './components/pages/Progressions'
import Profile from './components/pages/Profile'

import store from './store.js'

Vue.use(VueRouter);

const routes = [
  { path: '/home', name: 'home', component: Home },
  { path: '/parser', name: 'parser', component: AtlasParser },
  { path: '/trade', name: 'trade', component: MapTrade },
  { path: '/progressions', name: 'progressions', component: Progressions, meta: {auth: true} },
  { path: '/profile', name: 'profile', component: Profile, meta: {auth: true} },
  { path: '*', redirect: '/home' }
];

const router = new VueRouter({
  mode: 'history',
  routes
});

router.beforeEach((to, from, next) => {
  if(to.meta.auth && !store.state.apiKey){
    next('/');
  } else {
    next();
  }
});


export default router;