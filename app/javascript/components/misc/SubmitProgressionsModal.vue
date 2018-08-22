<template>
  <b-modal centered
           id="submit-progressions-modal"
           title="Confirm Submit"
           @ok="$emit('ok')"
           ref="loginModal">
    <b-form-checkbox v-model="status">
      Set me to online for 12 hours (Trade tool)
    </b-form-checkbox>
  </b-modal>
</template>

<script>
  export default {
    name: "SubmitProgressionsModal",
    data() {
      return {
        status: undefined
      }
    }
  }
</script>
