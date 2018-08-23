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

      <div v-else>
        <b-card header="Map Trade">
          Placeholder
        </b-card>
      </div>
  </div>
</template>

<script>
  export default {
    name: "MapTrade"
  }
</script>

<style scoped>

</style>