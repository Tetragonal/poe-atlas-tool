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
  getters: {
    minTier: state => {
      if(state.maps === undefined || state.maps.length === 0) return undefined;
      let minTier = state.maps[0].tier;
      for(let map in state.maps) {
        if(map.tier < minTier ) minTier = map.tier;
      }
      return minTier;
    },
    maxTier: state => {
      if(state.maps === undefined || state.maps.length === 0) return undefined;
      let maxTier = state.maps[0].tier;
      for(let map of state.maps) {
        if(map.tier > maxTier ) maxTier = map.tier;
      }
      return maxTier;
    },
    mapIdToTier: state => {
      if(state.maps === undefined || state.maps.length === 0) return undefined;
      return state.maps.reduce((map, obj) => {
        map[obj.id] = obj.tier;
        return map;
      }, {});
    },
    mapIdToName: state => {
      if(state.maps === undefined || state.maps.length === 0) return undefined;
      return state.maps.reduce((map, obj) => {
        map[obj.id] = obj.name;
        return map;
      }, {});
    },
    mapIdToUnique: state => {
      if(state.maps === undefined || state.maps.length === 0) return undefined;
      return state.maps.reduce((map, obj) => {
        map[obj.id] = obj.unique;
        return map;
      }, {});
    }
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