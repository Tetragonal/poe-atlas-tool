<template>
  <b-modal centered
           id="login-modal"
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
            // TODO handle incorrect api key
          }
        }
      }
    }
  }
</script>
