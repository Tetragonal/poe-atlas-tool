<template>
  <div id="app">
    <nav-bar></nav-bar>

    <div class="my-5 mx-auto" style="width: 80%">
      <transition name="fade" mode="out-in">
        <keep-alive>
          <router-view></router-view>
        </keep-alive>
      </transition>
    </div>
  </div>
</template>

<script>
  import NavBar from "./components/misc/NavBar";
  export default {
    name: 'App',
    components: {NavBar},
    created() {
      this.$store.commit('loadAtlasData');
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
