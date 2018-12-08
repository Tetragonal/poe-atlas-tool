<template>
  <div>
    <b-jumbotron v-if="!$store.state.apiKey">
      <template slot="header">
        Map Trade
      </template>
      <template slot="lead">
        A tool for exchanging duplicate same-tier maps with others. (WIP, but should partially work) <br> <br>
        To try it out, do the following: <br>
        1. To track what maps you need, link your PoE account (Account) and upload your atlas progression (Atlas Parser) <br>
        2. To track what maps you have, put completed/duplicate maps in a public stash tab with b/o 111 blessed. <br>
        3. Then, you can search for users to exchange maps with.
      </template>
      <hr class="my-4">
      <b-btn variant="info" v-b-modal.login-modal>Login</b-btn>
      <b-btn variant="info" v-b-modal.register-modal>Register</b-btn>
    </b-jumbotron>

    <div v-else>
      <b-card header="Map Trade">
        <b-alert :show="!$store.state.apiKey" variant="warning">
          To save your progression, link with your PoE account. (Account)
          <br>
          Doing this will allow you to easily search for users to trade with.
        </b-alert>
        <b-table striped hover small :items="tradeTableData" :fields="tradeTableFields" :sort-compare="sortTable">
          <template slot="completed" slot-scope="data">
            {{data.item.raw.progressions.length}}
          </template>
          <template slot="mapsOwned" slot-scope="data">
            {{data.item.stashedMaps.length}}
          </template>
          <template slot="trade" slot-scope="data">
            <b-button size="sm" @click.stop="openModal(data.item, $event.target)" class="mr-1">
              Trade ({{data.item.diffTotal}})
            </b-button>
          </template>
        </b-table>

        <!-- Trade Modal -->
        <trade-modal ref="tradeModal" :content="tradeModalData" ok-only></trade-modal>

        <b-dropdown :text="selectedLeague ? selectedLeague.name : 'Select league'">
          <b-dropdown-item v-for="elem in $store.state.leagues" @click="selectedLeague = elem">{{ elem.name }}</b-dropdown-item>
        </b-dropdown>
      </b-card>
    </div>
  </div>
</template>

<script>
  import api from '../../../api.js';
  import TradeModal from "./TradeModal";

  export default {
    name: "MapTrade",
    components: {TradeModal},
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

        tradeModalData: undefined
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
          const userStashedMapSet = new Set(user.stashed_maps);

          const ownStashedMapIds = new Set(this.ownStashedMaps.map(map => map.map_id));

          let diff = [];
          for (let i = this.$store.getters.minTier; i <= this.$store.getters.maxTier; i++) {
            diff.push({
              tier: i,
              ownMaps: Array.from(ownStashedMapIds).filter(mapId => !this.$store.getters.mapIdToUnique[mapId] && i === this.$store.getters.mapIdToTier[mapId] && !userProgressionSet.has(mapId) && !userStashedMapSet.has(mapId)),
              theirMaps: user.stashed_maps.filter(mapId => !this.$store.getters.mapIdToUnique[mapId] && i === this.$store.getters.mapIdToTier[mapId] && !ownProgressionSet.has(mapId) && !ownStashedMapIds.has(mapId)),
            });
          }

          data.push({
            raw: user,

            name: username,
            uncompletedMaps: uncompletedMaps,
            stashedMaps: user.stashed_maps,

            diff: diff,
            diffTotal: diff.reduce((sum, d) => sum + Math.min(d.ownMaps.length, d.theirMaps.length), 0)

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
        this.randomUsers = (await api.users.getRandom(this.$store.state.username, this.selectedLeague.id)).data;
      },
      async refresh() {
        this.loadOwnProgression();
        this.getRandomUsers();
      },
      sortTable(a, b, key) {
        switch(key) {
          case 'completed':
            return a.raw.progressions.length - b.raw.progressions.length;
          case 'mapsOwned':
            return a.stashedMaps.length - b.stashedMaps.length;
          case 'trade':
            return a.diffTotal - b.diffTotal;
          default:
            return null;
        }
      },
      openModal (data, content){
        this.tradeModalData = data;
        this.tradeModalData.league = this.selectedLeague;
        this.$refs.tradeModal.show()
      }
    }
  }
</script>

<style scoped>

</style>