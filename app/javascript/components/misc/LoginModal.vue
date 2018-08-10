<template>
  <div>
    <b-nav-item-dropdown text="Account"right>
      <b-dropdown-item v-b-modal.modal-center>Profile</b-dropdown-item>
      <b-dropdown-item>Signout</b-dropdown-item>
    </b-nav-item-dropdown>

    <!-- Modal Component -->
    <b-modal id="modal-center" centered title="Bootstrap-Vue">
      <p class="my-4">Vertically centered modal!</p>
    </b-modal>
  </div>
</template>

<script>
  export default {
    name: "LoginModal"
  }
  /*
    this.$store.commit('setUsername', 'Kevin');
    console.log(this.$store.state.username);
   */
</script>
