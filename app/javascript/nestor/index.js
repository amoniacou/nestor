import * as Vue from "vue";
import VueRouter from "vue-router";
import Vuetify from "vuetify";
import {
  store
} from "./store/index";
import router from "./router";

Vue.use(Vuetify);
import App from "./components/App.vue";
Vue.use(VueRouter);

const app = new Vue({
  router,
  store,
  ...App
});

export default app;