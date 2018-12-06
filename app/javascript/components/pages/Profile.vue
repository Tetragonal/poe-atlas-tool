<template>
  <div>
    <b-card header="Profile">
    </b-card>
  </div>
</template>

<script>
  export default {
    name: "Profile",
    data() {
      return {
        mapTableFields: [
          {
            key: 'name',
            sortable: true
          },
          {
            key: 'tier',
            sortable: true
          },
          {
            key: 'unique',
            sortable: true,
          },
          {
            key: 'completed',
            sortable: true,
          }
        ]
      }
    },
    created() {

    }
  }
</script>
