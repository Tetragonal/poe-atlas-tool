import Vue from 'vue'
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    username: undefined,
    apiKey: undefined
  },
  mutations: {
    setUsername (state, username) {
      state.username = username;
    },
    setApiKey (state, apiKey) {
      state.apiKey = apiKey;
    },
    logout(state) {
      state.username = undefined;
      state.apiKey = undefined;
    }
  }
});