/**
 * Contains front-end API endpoints
 */

const axios = require('axios');

const API_URL = "/api/v1";

export default {
  maps: {
    get: () => axios.get(API_URL + '/maps')
  },
  leagues: {
    get: () => axios.get(API_URL + '/leagues')
  },
  progressions: {
    post: (apiKey, leagueId, mapIds) => axios.post(API_URL + '/progressions',
        {leagueId, mapIds},
        {headers: {Authorization: apiKey}})
  },
  login: {
    post: (apiKey) => axios.post(API_URL + '/login',
        {api_key: apiKey})
  },
  register: {
    post: (username) => axios.post(API_URL + '/users/' + encodeURIComponent(username))
  }
}