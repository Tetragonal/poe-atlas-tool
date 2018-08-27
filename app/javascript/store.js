import Vue from 'vue'
import Vuex from 'vuex';

import api from './api';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    username: undefined,
    apiKey: undefined,

    maps: undefined,
    leagues: undefined
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
    },
    async loadAtlasData(state) {
      let mapPromise = api.maps.get();
      let leaguePromise = api.leagues.get();

      state.maps = (await mapPromise).data.maps;
      state.leagues = (await leaguePromise).data.leagues;
    },
  }
});