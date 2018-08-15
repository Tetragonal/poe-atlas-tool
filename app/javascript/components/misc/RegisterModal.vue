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
                  placeholder="Enter your username"
                  @keyup.enter.native="handleRegister"></b-form-input>
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
