<template>
  <div>
    <b-jumbotron v-if="!$store.state.apiKey">
      <template slot="header">
        Map Trade
      </template>
      <template slot="lead">
        Placeholder
      </template>
      <hr class="my-4">
      <b-btn variant="info" v-b-modal.login-modal>Login</b-btn>
      <b-btn variant="info" v-b-modal.register-modal>Register</b-btn>
    </b-jumbotron>

    <div v-else>
      <b-card header="Map Trade">
        Placeholder
        <b-table striped hover small :items="tradeTableData" :fields="tradeTableFields">
          <template slot="completed" slot-scope="data">
            {{data.item.uncompletedMaps.length}}
          </template>
          <template slot="mapsOwned" slot-scope="data">
            {{data.item.stashedMaps.length}}
          </template>
          <template slot="trade" slot-scope="data">
            <b-button>Trade</b-button>
          </template>
        </b-table>

        <b-dropdown :text="selectedLeague ? selectedLeague.name : 'Select league'">
          <b-dropdown-item v-for="elem in $store.state.leagues" @click="selectedLeague = elem">{{ elem.name }}</b-dropdown-item>
        </b-dropdown>
      </b-card>
    </div>
  </div>
</template>

<script>
  import api from '../../../api.js';

  export default {
    name: "MapTrade",
    data() {
      return {
        ownProgression: undefined,
        ownStashedMaps: undefined,

        randomUsers: undefined,

        selectedLeague: undefined,

        tradeTableFields: [
          {
            key: 'name',
            sortable: true
          },
          {
            key: 'completed',
            sortable: true
          },
          {
            key: 'mapsOwned',
            sortable: true
          },
          {
            key: 'trade',
            sortable: true
          }
        ],
      }
    },
    watch: {
      '$store.state.username' (newVal) {
        if (newVal !== undefined && this.selectedLeague !== undefined) {
          this.refresh();
        }
      },
      selectedLeague (newVal) {
        if(newVal !== undefined && this.$store.state.username !== undefined) {
          this.refresh();
        }
      }
    },
    computed: {
      ownUncompletedMaps () {
        if(this.$store.state.maps === undefined || this.ownProgression === undefined) return undefined;
        return this.$store.state.maps.filter(map => !this.ownProgression.includes(map.id));
      },
      tradeTableData () {
        if(this.ownProgression === undefined || this.ownStashedMaps === undefined || this.randomUsers === undefined) return undefined;

        const ownProgressionSet = new Set(this.ownProgression);

        let data = [];
        for (const username in this.randomUsers) {
          if(!this.randomUsers.hasOwnProperty(username)) continue;
          const user = this.randomUsers[username];

          // Calculate maps
          const uncompletedMaps = this.$store.state.maps.filter(map => !user.progressions.includes(map.id));
          const userProgressionSet = new Set(user.progressions);

          let diff = [];
          for (let i = this.$store.getters.minTier; i <= this.$store.getters.maxTier; i++) {
            console.log(username + ' ' + JSON.stringify(user));
            diff.push({
              tier: i,
              ownMaps: this.ownStashedMaps.filter(mapId => i === this.$store.getters.mapIdToTier[mapId] && !userProgressionSet.has(mapId)),
              theirMaps: user.stashed_maps.filter(mapId => i === this.$store.getters.mapIdToTier[mapId] && !ownProgressionSet.has(mapId)),
            });
          }

          data.push({
            raw: user,

            name: username,
            uncompletedMaps: uncompletedMaps,
            stashedMaps: user.stashed_maps,

            diff: diff

          });
        }
        return data;
      }
    },
    methods: {
      async loadOwnProgression() {
        if (this.$store.state.username) {
          this.ownProgression = (await api.progressions.get(this.$store.state.username)).data.maps;
          this.ownStashedMaps = (await api.stashedMaps.get(this.$store.state.username)).data.maps;
        }
      },
      async getRandomUsers() {
        this.randomUsers = (await api.users.getRandom(this.selectedLeague.id)).data;
      },
      async refresh() {
        this.loadOwnProgression();
        this.getRandomUsers();
      }
    }
  }
</script>

<style scoped>

</style>