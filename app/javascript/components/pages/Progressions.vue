<template>
  <div>
    Progressions Placeholder
    <b-dropdown :text="selectedLeague ? selectedLeague.name : 'Select league'">
      <b-dropdown-item v-for="elem in $store.state.leagues" @click="selectedLeague = elem; $store.commit('refreshProgressions', selectedLeague.id)">{{ elem.name }}</b-dropdown-item>
    </b-dropdown>
    <b-table striped hover small
             :items="$store.state.maps"
             :fields="mapTableFields"
             :sort-compare="sortTable"
             v-if="$store.state.progressions !== undefined">
      <template slot="unique" slot-scope="data">
        <b-badge pill variant="warning">{{ data.item.unique ? 'Unique' : '' }}</b-badge>
      </template>
      <template slot="completed" slot-scope="data">
        <b-badge pill variant="success">{{ $store.state.progressions.has(data.item.id) ? 'Complete' : '' }}</b-badge>
      </template>
    </b-table>
  </div>
</template>

<script>
  export default {
    name: "Progressions",
    data() {
      return {
        selectedLeague: undefined,

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
    methods: {
      sortTable(a, b, key) {
        if (key === 'completed') {
          if (this.$store.state.progressions.has(a.id) && this.$store.state.progressions.has(b.id)) return 0;
          if (this.$store.state.progressions.has(a.id)) return -1;
          return 1;
        } else if (key === 'unique') {
          if (a.unique && b.unique) return 0;
          if (a.unique) return -1;
          return 1;
        } else return null;
      }
    },
  }
</script>
