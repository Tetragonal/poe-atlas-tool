/**
 * Contains front-end API endpoints
 */

const axios = require('axios');

const API_URL = "/api/v1";

export default {
  maps() {
    return {
      get: () => axios.get(API_URL + '/maps')
    }
  },
  leagues() {
    return {
      get: () => axios.get(API_URL + '/leagues')
    }
  }
}