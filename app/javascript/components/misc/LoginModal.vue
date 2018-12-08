<template>
  <b-modal centered
           id="login-modal"
           title="Login"
           @ok="handleLogin"
           @shown="formText = ''; $refs.loginInput.focus()"
           ref="loginModal">
    <b-form-input ref="loginInput"
                  class="mb-3"
                  v-model="formText"
                  type="text"
                  :state="formText !== '' ? null : false"
                  placeholder="Enter your API key"
                  @keyup.enter.native="handleLogin"></b-form-input>
    After linking your PoE account, paste the key sent to your in-game mail. <br>
    (On the site, go to Private messages -> Inbox)
    <b-alert :show="error" variant="danger">{{ errorText }}</b-alert>
  </b-modal>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "LoginModal",
    data() {
      return {
        formText: '',
        error: false,
        errorText: ''
      }
    },
    methods: {
      async handleLogin(e) {
        e.preventDefault();
        this.error = false;
        this.errorText = '';
        if (this.formText !== '') {
          try {
            this.$store.commit('setUsername', (await api.login.post(this.formText)).data.username);
            this.$store.commit('setApiKey', this.formText);

            this.$refs.loginModal.hide();
          } catch (err) {
            this.error = true;
            if(err.response){
              switch (err.response.status) {
                case 401: // Unauthorized
                  this.errorText = 'Invalid API key. If you have already registered, the key should be in your PoE account mail.';
                  break;
                default: // 500
                  this.errorText = 'An unknown error occurred.';
                  break;
              }
            }
            else this.errorText = 'Could not login (check internet connection)';
          }
        }
      }
    }
  }
</script>
