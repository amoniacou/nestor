import VueRouter from 'vue-router';

import Home from './views/Home.vue';

const routes = [{
  path: '/',
  name: 'Home',
  component: Home
  }
];

const router = new VueRouter({
  mode: 'history',
  routes // short for routes: routes
});

export default router;