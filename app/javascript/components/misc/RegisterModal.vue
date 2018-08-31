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
    An API key will be sent to you via in-game mail, which you can use to log in.
  </b-modal>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "RegisterModal",
    data() {
      return {
        formText: ''
      }
    },
    methods: {
      async handleRegister(e) {
        e.preventDefault();
        if (this.formText !== '') {
          try {
            await api.register.post(this.formText);

            this.$refs.registerModal.hide();
          } catch (err) {
            alert(err.response.status);
            // TODO handle incorrect username
          }
        }
      }
    }
  }
</script>
