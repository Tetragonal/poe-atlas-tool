import Vue from 'vue'
import store from './store.js'

//const BASE = 'https://www.pathofexile.com/api/trade/search/';
const BASE = 'https://www.pathofexile.com/api/trade/exchange/';
const QUERY_FIELDS = '?redirect&source=';
/*
const QUERY_OBJ = {
  "query": {
    "status": {
      "option": "online"
    },
    "filters": {
      "type_filters": {
        "filters": {
          "category": {
            "option": "map"
          }
        }
      },
      "map_filters": {
        "disabled": false,
        "filters": {
          "map_shaped": {
            "option": false
          },
          "map_elder": {
            "option": false
          }
        }
      }
    },
    "type": {
      "option": undefined
    }
  }
};
*/

const QUERY_OBJ = {
  "exchange": {
    "status": {
      "option": "online"
    },
    "have": [],
    "want": []
  }
};

const mapNameToQuery = (mapName) => {
  return mapName.toLowerCase().split(' ').join('-') + '-map';
};

Vue.mixin({
  methods: {
    generateTradeLink: (leagueName, mapIds) => {
      let queryObj = Object.assign({}, QUERY_OBJ);
      for (let mapId in mapIds) {
        const mapName = store.getters.mapIdToName[mapId];
        queryObj.exchange.want.push(mapNameToQuery(mapName));
      }
      return BASE + leagueName + QUERY_FIELDS + encodeURIComponent(JSON.stringify(queryObj));
    },
    generatePoeAppTradeLink: (leagueName, mapIds) => {
      // https://poeapp.com/#/currency/{"need":["Alleyways Map","Ancient City Map"],"league":"standard","stock":"","have":["Chaos Orb"]}
    },
    generateTradeWhisper: (lastCharacterName, leagueName, tier, ownMaps, theirMaps) => {
      return '@' + lastCharacterName + ' Hi, I would like to trade the following tier ' + tier + ' maps in ' + leagueName + ': My [' + ownMaps.join(', ') + '] for your [' + theirMaps.join(', ') + ']';
    },
    openTab: (url) => {
      window.open(url, '_blank');
    }
  }
});