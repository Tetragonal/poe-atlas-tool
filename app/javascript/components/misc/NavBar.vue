<template>
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
        <login-modal></login-modal>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>

<script>
  import LoginModal from "./LoginModal";

  export default {
    name: "NavBar",
    components: {LoginModal}
  }
</script>

<style scoped>

</style>