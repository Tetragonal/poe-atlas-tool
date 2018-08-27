/**
 * Contains front-end API endpoints
 */

const axios = require('axios');

axios.defaults.baseURL = '/api/v1';

export default {
  maps: {
    get: () => axios.get('/maps')
  },
  leagues: {
    get: () => axios.get('/leagues')
  },
  progressions: {
    get: (username) => axios.get('/progressions/' + encodeURIComponent(username)),
    post: (apiKey, username, leagueName, mapIds) => axios.post('/progressions',
        {account_name: username, league: leagueName, maps: mapIds},
        {headers: {Authorization: apiKey}})
  },
  login: {
    post: (apiKey) => axios.post('/login',
        {api_key: apiKey})
  },
  register: {
    post: (username) => axios.post('/users/' + encodeURIComponent(username))
  },
  users: {
    getRandom: () => axios.get('/users')
  }
}