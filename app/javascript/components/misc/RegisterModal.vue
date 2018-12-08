<template>
  <b-modal centered
           id="register-modal"
           title="Register"
           @ok="handleRegister"
           @shown="formText = ''; $refs.registerInput.focus()"
           ref="registerModal">
    <b-form-input ref="registerInput"
                  v-model="formText"
                  type="text"
                  :state="formText !== '' ? null : false"
                  placeholder="Enter your PoE account name"
                  @keyup.enter.native="handleRegister"
                  class="mb-2"></b-form-input>
    An account key will be generated and sent to you via PoE's in-game mail, which you can use to log in.<br><br>
    This tool isn't affiliated with PoE or GGG in any way, the key is used to link (in-game account <-> this site).
    <b-alert class="mt-2" :show="error" variant="danger">{{ errorText }}</b-alert>
  </b-modal>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "RegisterModal",
    data() {
      return {
        formText: '',
        error: false,
        errorText: ''
      }
    },
    methods: {
      async handleRegister(e) {
        e.preventDefault();
        this.error = false;
        this.errorText = '';
        if (this.formText !== '') {
          try {
            await api.register.post(this.formText);

            this.$refs.registerModal.hide();
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
