import Vue from 'vue'
import store from './store.js'

const POE_BASE = 'https://www.pathofexile.com/api/trade/exchange/';
const POE_QUERY_FIELDS = '?redirect&source=';
const POE_QUERY_OBJ = {
  "exchange": {
    "status": {
      "option": "online"
    },
    "have": ["chaos", "chisel", "alch"],
    "want": []
  }
};

const POEAPP_BASE = 'https://poeapp.com/#/currency/';
const POEAPP_QUERY_OBJ = {
  "need": [], //"Alleyways Map","Ancient City Map"
  "league": undefined,
  "have":["Chaos Orb", "Cartographer's Chisel", "Orb of Alchemy"]
};


const mapNameToQuery = (mapName) => {
  return mapName.toLowerCase().split(' ').join('-') + '-map';
};

const mapNameToPoeAppQuery = (mapName) => {
  return mapName + " Map"; // Doesn't work for unique maps
};

Vue.mixin({
  methods: {
    generateTradeLink: (leagueName, mapIds) => {
      let queryObj = Object.assign({}, POE_QUERY_OBJ);
      for (let mapId of mapIds) {
        const mapName = store.getters.mapIdToName[mapId];
        queryObj.exchange.want.push(mapNameToQuery(mapName));
      }
      return POE_BASE + leagueName + POE_QUERY_FIELDS + encodeURIComponent(JSON.stringify(queryObj));
    },
    generatePoeAppTradeLink: (leagueName, mapIds) => {
      let queryObj = Object.assign({}, POEAPP_QUERY_OBJ);
      queryObj.league = leagueName.toLowerCase();
      for (let mapId of mapIds) {
        const mapName = store.getters.mapIdToName[mapId];
        queryObj.need.push(mapNameToPoeAppQuery(mapName));
      }
      return POEAPP_BASE + encodeURIComponent(JSON.stringify(queryObj));

    },
    generateTradeWhisper: (lastCharacterName, leagueName, tier, ownMaps, theirMaps) => {
      return '@' + lastCharacterName + ' Hi, I would like to trade the following tier ' + tier + ' maps in ' + leagueName + ': My [' + ownMaps.join(', ') + '] for your [' + theirMaps.join(', ') + ']';
    },
    openTab: (url) => {
      window.open(url, '_blank');
    },
    objectLength: (obj) => {
      return Object.keys(obj).length;
    }
  }
});