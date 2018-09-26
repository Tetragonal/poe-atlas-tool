<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Atlas Tool
      </template>
      <template slot="lead">
        A combination of utilities with the purpose of streamlining Atlas map
        progression, including a screenshot parser, progression tracker, and trade tool.
      </template>
      <hr class="my-4">
      <b-btn variant="primary" to="/parser">Atlas Parser</b-btn>
      <b-btn variant="success" to="/trade">Map Trade</b-btn>
    </b-jumbotron>
  </div>
</template>

<script>
  export default {
    name: "Home"
  }
</script>
