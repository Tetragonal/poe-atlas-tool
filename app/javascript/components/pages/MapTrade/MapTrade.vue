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

        randomUsers: undefined
      }
    },
    watch: {
      '$store.state.username'(newVal) {
        if(newVal !== undefined) {
          this.refresh();
        }
      }
    },
    computed: {
      tradeTableData() {
        if(this.ownProgression === undefined || this.ownStashedMaps === undefined || this.randomUsers === undefined) return undefined;

        let data = [];
        for(let i = 0; i < randomUsers.length; i++){
          // Calculate
          data.push({
          });
        }
      }
    },
    methods: {
      async loadOwnProgression() {
        if (this.$store.state.username) {
          this.ownProgression = (await api.progressions.get(this.$store.state.username)).maps;
        }
      },
      async getRandomUsers() {
        this.randomUsers = await api.users.getRandom();
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