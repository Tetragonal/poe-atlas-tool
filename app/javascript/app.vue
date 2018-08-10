<template>
  <div id="app">
    <nav-bar></nav-bar>

    <div class="my-5 mx-auto" style="width: 80%">
      <keep-alive>
        <router-view></router-view>
      </keep-alive>
    </div>
  </div>
</template>

<script>
  import NavBar from "./components/misc/NavBar";
  export default {
    name: 'App',
    components: {NavBar}
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
