<template>
  <b-modal centered
           size="lg"
           title="Trade"
           ref="tradeModal">
    <div v-if="content">
      <b-table striped hover small :items="diffTableData" :fields="diffTableFields">
        <template slot="ownMaps" slot-scope="data">
          {{data.item.ownMaps.reduce((acc, curr) => acc + ', ' + curr)}}
        </template>
        <template slot="theirMaps" slot-scope="data">
          {{data.item.theirMaps.reduce((acc, curr) => acc + ', ' + curr)}}
        </template>
        <template slot="clipboard" slot-scope="data">
          <b-button size="sm" block
                    v-clipboard="generateTradeWhisper(content.name, content.league.name, data.item.tier, data.item.ownMaps, data.item.theirMaps)"
                    @success="copyIndex = data.index">{{copyIndex === data.index ? 'Copied!' : 'Copy link'}}</b-button>
        </template>
      </b-table>
    </div>
  </b-modal>
</template>

<script>
  export default {
    name: "TradeModal",
    props: {
      content: {
        type: Object,
        required: false
      }
    },
    data() {
      return {
        diffTableFields: [
          {
            key: 'tier',
            sortable: true
          },
          {
            key: 'ownMaps',
            sortable: false
          },
          {
            key: 'theirMaps',
            sortable: false
          },
          {
            key: 'clipboard',
            label: 'Copy to clipboard',
            sortable: false
          }
        ],
        copyIndex: -1
      }
    },
    computed: {
      diffTableData () {
        if (this.content === undefined) return undefined;

        let tableData = [];
        for (let diff of this.content.diff) {
          if (diff.ownMaps.length === 0 || diff.theirMaps.length === 0) continue;
          tableData.push({
            tier: diff.tier,
            ownMaps: diff.ownMaps.map((mapId) => this.$store.getters.mapIdToName[mapId]),
            theirMaps: diff.theirMaps.map((mapId) => this.$store.getters.mapIdToName[mapId])
          });
        }
        return tableData;
      }
    },
    methods: {
      show() {
        this.$refs.tradeModal.show();
      }
    }
  }
</script>
