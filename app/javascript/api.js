/**
 * Contains front-end methods to call API
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
    get: (username, leagueId) => axios.get('/progressions/' + encodeURIComponent(username),
        {params: {league_id: leagueId}}),
    post: (apiKey, username, leagueName, mapIds) => axios.post('/progressions/' + encodeURIComponent(username),
        {league: leagueName, maps: mapIds},
        {headers: {Authorization: apiKey}})
  },
  stashedMaps: {
    get: (username, leagueId) => axios.get('/stashed_maps/' + encodeURIComponent(username),
        {params: {league_id: leagueId}})
  },
  login: {
    post: (apiKey) => axios.post('/login',
        {api_key: apiKey})
  },
  register: {
    post: (username) => axios.post('/users/' + encodeURIComponent(username))
  },
  users: {
    getRandom: (username, leagueId) => axios.get('/users/' + encodeURIComponent(username) + '/random', {params: {league_id: leagueId}})
  }
}