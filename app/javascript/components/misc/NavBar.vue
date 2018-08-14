<template>
<div>
  <b-navbar toggleable="md" type="dark" variant="info">

    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand>PoE Atlas Tool</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">

      <b-navbar-nav>
        <b-nav-item to="/home">Home</b-nav-item>
        <b-nav-item to="/parser">Atlas Parser</b-nav-item>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <!-- Logged in -->
        <div v-if="$store.state.username">
          <b-nav-item-dropdown :text="$store.state.username"right>
            <b-dropdown-item to="/profile">Profile</b-dropdown-item>
            <b-dropdown-item to="/progressions">Atlas Progression</b-dropdown-item>
            <b-dropdown-item @click="logout">Signout</b-dropdown-item>
          </b-nav-item-dropdown>
        </div>

        <!-- Logged out -->
        <div v-else>
          <b-nav-item-dropdown text="Account"right>
            <b-dropdown-item v-b-modal.login-modal>Login</b-dropdown-item>
            <b-dropdown-item>Register</b-dropdown-item>
          </b-nav-item-dropdown>
        </div>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>

  <login-modal></login-modal>

</div>
</template>

<script>
  import LoginModal from "./LoginModal";

  export default {
    name: "NavBar",
    components: {LoginModal},
    methods: {
      logout() {
        this.$store.commit('logout');
      }
    }
  }
</script>

<style scoped>

</style>