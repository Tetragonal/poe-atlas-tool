<template>
  <div>
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
        <b-dropdown-item v-b-modal.modal-center>Login</b-dropdown-item>
        <b-dropdown-item>Register</b-dropdown-item>
      </b-nav-item-dropdown>
    </div>
    <!-- Modal Component -->
    <b-modal centered
             id="modal-center"
             title="Login"
             @ok="handleLogin"
             @shown="formText = ''; $refs.loginInput.focus()"
             ref="loginModal">
      <b-form-input ref="loginInput"
                    v-model="formText"
                    type="text"
                    :state="formText !== '' ? null : false"
                    placeholder="Enter your API key"
                    @keyup.enter.native="handleLogin"></b-form-input>
    </b-modal>
  </div>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "LoginModal",
    data() {
      return {
        formText: ''
      }
    },
    methods: {
      async handleLogin(e) {
        e.preventDefault();
        if (this.formText !== '') {
          try {
            this.$store.commit('setUsername', (await api.login.post(this.formText)).data.username);
            this.$store.commit('setApiKey', this.formText);

            this.$refs.loginModal.hide();
          } catch (err) {
            console.log(err);
            alert('rib');
          }
        }
      },
      logout() {
        this.$store.commit('logout');
      }
    }
  }
</script>
