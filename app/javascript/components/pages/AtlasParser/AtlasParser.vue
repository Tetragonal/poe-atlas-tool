<template>
  <div>
    <b-card :header="atlasImage ? '' : 'Atlas Parser'"
            :img-src="atlasImage"
            img-alt="Image"
            img-top>
      <!-- File Selector -->
      <div class="card-body">
        <b-form-file v-model="atlasFile" accept="image/*" placeholder="Choose a file..."></b-form-file>
      </div>


        <!-- Instructions -->
        <div v-if="atlasImage === undefined">
          <b-alert show variant="warning">
            The parser will only align properly with well-formatted or cropped fullscreen screenshots. <br>
            If it doesn't work the first time, see below or try the demo to see an example formatted image.
          </b-alert>
          <b-alert show variant="secondary">
            Instructions: <br>
            Open the Atlas screen (Default keybind: G). Take and upload a screenshot with the game in fullscreen mode. <br> <br>
            On Windows, you can switch to fullscreen with the shortcut Alt-Enter and use the Print Screen function. <br>
            Alternatively, you can use Snipping Tool with the game in borderless fullscreen.
          </b-alert>
          <b-button @click="setupDemo">
            Load demo
          </b-button>
        </div>

        <!-- Results -->
        <div v-else>
          <hr>

          <!-- Overview -->
          <div class="card-body">
            <h3 class="card-text">
              Completion Overview
            </h3>

            <b-alert show variant="warning">
              Make sure to check the Map Preview section to verify that the parsing has been done correctly.
              <br>
              If the image does not align with the maps, try taking the screenshot again in fullscreen mode.
            </b-alert>

            <b-card-group deck>
              <b-card header="Atlas Progress">
                <h3 class="card-text">
                  {{ completedMaps.size }}/{{ $store.state.maps.length }} maps completed
                  ({{(100.0*completionStats.regular.completed/completionStats.regular.count).toFixed(0)}}%)
                </h3>
                <p class="card-text" v-if="lowestUncompletedMap">
                  Lowest uncompleted map: {{ lowestUncompletedMap.name }} (Tier {{ lowestUncompletedMap.tier }})
                </p>

                <hr>

                <p class="card-text">
                  {{ completionStats.regular.completed }}/{{ completionStats.regular.count }} regular maps completed
                  ({{(100.0*completionStats.regular.completed/completionStats.regular.count).toFixed(0)}}%)
                </p>
                <b-progress class="mb-3" style="height:25px" :max="completionStats.regular.count" show-value>
                  <b-progress-bar :value="completionStats.regular.completed" variant="success"></b-progress-bar>
                  <b-progress-bar :value="completionStats.regular.count - completionStats.regular.completed" variant="secondary"></b-progress-bar>
                </b-progress>
                <p class="card-text">
                  {{ completionStats.unique.completed }}/{{ completionStats.unique.count }} unique maps completed
                  ({{(100.0*completionStats.unique.completed/completionStats.unique.count).toFixed(0)}}%)
                </p>
                <b-progress class="mb-3" style="height:25px" :max="completionStats.unique.count" show-value>
                  <b-progress-bar :value="completionStats.unique.completed" variant="success"></b-progress-bar>
                  <b-progress-bar :value="completionStats.unique.count - completionStats.unique.completed" variant="secondary"></b-progress-bar>
                </b-progress>
                <hr>
              </b-card>
              <b-card header="Map Preview">
                <b-input-group class="mb-3"
                               prepend="Tier"
                               :append="'(' + Array.from(completedMaps).filter(map => map.tier === selectedPreviewTier).length + '/' + previewImages[selectedPreviewTier].length + ' completed)'">
                  <b-form-input type="number" :min="$store.getters.minTier" :max="$store.getters.maxTier" v-model.number="selectedPreviewTier"></b-form-input>
                </b-input-group>

                <span v-for="(tier, index) in previewImages" v-if="index === selectedPreviewTier">
                <b-img v-for="map in tier" :src="map.dataURL" width="40px"
                       v-b-tooltip :title="map.name"></b-img>
              </span>
              </b-card>
            </b-card-group>
          </div>

          <!-- Details -->
          <div class="card-body" v-if="!demo">
            <hr>

            <h3 class="card-text">
              Save Atlas Progression
            </h3>
            <b-alert :show="!$store.state.apiKey" variant="warning">
              To save your progression, you must be logged in.
              <br>
              Doing this will let you search for users with similar atlas progression to trade with.
            </b-alert>
            <div>
              <b-button-group>
                <b-dropdown :text="selectedLeague ? selectedLeague.name : 'Select league'">
                  <b-dropdown-item v-for="elem in $store.state.leagues" @click="selectedLeague = elem">{{ elem.name }}</b-dropdown-item>
                </b-dropdown>

                <b-button v-b-modal.submit-progressions-modal v-if="selectedLeague && $store.state.apiKey">
                  Submit
                </b-button>
                <b-button disabled v-else>
                  Submit
                </b-button>
              </b-button-group>
            </div>
          </div>

          <!-- Completed maps-->
          <div class="card-body">
            <b-card>
              <div slot="header">
                <b-row>
                  <b-col>Trade Helper</b-col>
                  <b-col class="text-right">
                    <b-form-checkbox v-model="hideCompleted">Hide completed</b-form-checkbox>
                    <b-dropdown size="sm" :text="selectedLeague ? selectedLeague.name : 'Select league'">
                      <b-dropdown-item v-for="elem in $store.state.leagues" @click="selectedLeague = elem">{{ elem.name }}</b-dropdown-item>
                    </b-dropdown>
                    <b-button size="sm"
                              :disabled="selectedLeague === undefined || selectedIds.length === 0"
                              @click="openTab(generateTradeLink(selectedLeague.name, selectedIds))">
                      Official
                    </b-button>
                    <b-button size="sm"
                              :disabled="selectedLeague === undefined || selectedIds.length === 0"
                              @click="openTab(generatePoeAppTradeLink(selectedLeague.name, selectedIds))">
                      PoEApp
                    </b-button>
                    <b-button size="sm"
                              :disabled="selectedLeague === undefined || selectedIds.length === 0"
                              @click="openTab(generatePoeTradeLink(selectedLeague.name, selectedIds))">
                      PoETrade
                    </b-button>
                  </b-col>
                </b-row>
              </div>
              <b-table striped hover small :items="filteredMaps" :fields="mapTableFields" :sort-compare="sortTable" :fixed="true">
                <template slot="HEAD_selected" slot-scope="data">
                  <b-form-checkbox @click.native.stop v-model="allSelected" class="table-checkbox"></b-form-checkbox>
                </template>
                <template slot="selected" slot-scope="data">
                  <b-form-checkbox v-model="checked[data.item.id]" v-if="!completedMaps.has(data.item) && !$store.getters.mapIdToUnique[data.item.id]" class="table-checkbox"></b-form-checkbox>
                </template>
                <template slot="unique" slot-scope="data">
                  <b-badge pill variant="warning">{{ data.item.unique ? 'Unique' : '' }}</b-badge>
                </template>
                <template slot="completed" slot-scope="data">
                  <b-badge pill variant="success">{{ completedMaps.has(data.item) ? 'Complete' : '' }}</b-badge>
                </template>
              </b-table>
            </b-card>
          </div>
        </div>
    </b-card>
    <submit-progressions-modal @ok="submitProgressions"></submit-progressions-modal>
  </div>
</template>

<script>
  import tinycolor from 'tinycolor2';
  import api from '../../../api.js';
  import SubmitProgressionsModal from "./SubmitProgressionsModal";
  import demoAtlas from '../../../../../public/images/demo.jpg';

  export default {
    name: "AtlasParser",
    components: {SubmitProgressionsModal},
    data() {
      return {
        // For upload
        atlasFile: undefined,
        selectedLeague: undefined,

        // Created from screenshot
        completedMaps: undefined,
        atlasImage: undefined,

        // Preview
        previewImages: [],
        selectedPreviewTier: 1,

        demo: false,

        mapTableFields: [
          {
            key: 'selected',
            sortable: false,
            thStyle: {width: '100px'}
          },
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
        ],
        checked: {},
        selectedIds: [],
        allSelected: false,
        hideCompleted: false
      }
    },
    watch: {
      atlasFile() {
        this.readImage();
      },
      allSelected(newVal) {
        for (let map of this.$store.state.maps) {
          this.$set(this.checked, map.id, newVal);
        }
      },
      checked: {
        handler(newVal){
          let selected = [];
          for (let id in newVal) {
            if (newVal[id]) {
              selected.push(id);
            }
          }
          this.selectedIds = selected;
        },
        deep: true
      }
    },
    computed: {
      filteredMaps() {
        return this.hideCompleted
            ? this.$store.state.maps.filter(x => !this.completedMaps.has(x))
            : this.$store.state.maps;
      },
      lowestUncompletedMap() {
        if(this.$store.state.maps === undefined) return undefined;
        let lowestMap = undefined;
        for(let map of this.$store.state.maps){
          if(map.unique) continue;
          if(!this.completedMaps.has(map)){
            if(lowestMap === undefined || lowestMap.tier > map.tier) lowestMap = map;
          }
        }
        return lowestMap;
      },
      completionStats() {
        return {
          regular: {
            count: Array.from(this.$store.state.maps).filter(map => !map.unique).length,
            completed: Array.from(this.completedMaps).filter(map => !map.unique).length
          },
          unique: {
            count: Array.from(this.$store.state.maps).filter(map => map.unique).length,
            completed: Array.from(this.completedMaps).filter(map => map.unique).length
          }
        }
      }
    },
    methods: {
      readImage() {
        // Read file
        let reader = new FileReader();
        reader.onloadend = () => {
          let img = new Image();
          img.src = reader.result;
          img.onload = () => {
            this.parseScreenshot(img);
          }
        };
        reader.readAsDataURL(this.atlasFile);
        this.demo = false;
      },
      setupDemo() {
        let img = new Image();
        img.src = demoAtlas;
        img.onload = () => {
          this.parseScreenshot(img);
        };
        this.demo = true;
      },
      submitProgressions() {
        let mapIds = [];
        for(let map of this.completedMaps){
          mapIds.push(map.id);
        }
        api.progressions.post(this.$store.state.apiKey, this.$store.state.username, this.selectedLeague.name, mapIds);
      },
      parseScreenshot(img) {
        //image height is 563px
        const HEIGHT = 563;
        //image width is 1000px
        const WIDTH = 1000;
        //search (8+1+8) = 17x17 area
        const RECT_SIZE = 8;
        const RECT_LENGTH = (2 * (RECT_SIZE + 1));
        //Hue: 15 - 45
        const MIN_HUE = 15, MAX_HUE = 45;
        //Sat: 20 - 50
        const MIN_SAT = .25, MAX_SAT = .4;
        //Val: .25 - .60 Mostly to filter out Shaper's space background
        const MIN_VAL = .30, MAX_VAL = .60;
        //Pixels matched threshold for map to be considered completed: 9%.
        const THRESHOLD = .09;
        //move Shaper's Realm to 491.8 to 500
        const X_OFFSET = 8;
        const Y_OFFSET = 56;


        const getColorIndicesForCoord = (x, y, width) => {
          const red = y * (width * 4) + x * 4;
          return [red, red + 1, red + 2, red + 3];
        };

        const scale = HEIGHT / img.height;
        const width = Math.floor(scale * img.width);

        let canvas = document.createElement('canvas');
        canvas.width = Math.max(width, WIDTH);
        canvas.height = HEIGHT;
        let ctx = canvas.getContext('2d', {alpha: false});

        ctx.drawImage(img, Math.max(0, Math.round((WIDTH - width) / 2)), 0, width, HEIGHT);
        let imgData = ctx.getImageData(Math.max(0, Math.round((width - WIDTH) / 2)), 0, WIDTH, HEIGHT); //take center WIDTH x HEIGHT of canvas
        let data = imgData.data;

        //Processing
        let matchedNames = new Set();

        for (let i = 0; i < this.$store.state.maps.length; i++) {

          const point = {
            x: this.$store.state.maps[i].atlas_x + X_OFFSET,
            y: this.$store.state.maps[i].atlas_y + Y_OFFSET
          };

          // Count the number of pixels within the hsv range
          let count = 0;
          for (let y = point.y - RECT_SIZE; y <= point.y + RECT_SIZE; y++) {
            for (let x = point.x - RECT_SIZE; x <= point.x + RECT_SIZE; x++) {
              let coords = getColorIndicesForCoord(Math.round(x), Math.round(y), WIDTH);
              let hsv = tinycolor({
                r: data[coords[0]],
                g: data[coords[1]],
                b: data[coords[2]]
              }).toHsv();
              if (hsv.h >= MIN_HUE && hsv.h <= MAX_HUE && hsv.s
                  && hsv.s >= MIN_SAT && hsv.s <= MAX_SAT
                  && hsv.v >= MIN_VAL && hsv.v <= MAX_VAL) {
                count++;
              }
            }
          }
          // If passes threshold, mark the map as completed
          if (count / (RECT_LENGTH * RECT_LENGTH) > THRESHOLD) {
            matchedNames.add(this.$store.state.maps[i]);
          }
        }
        this.completedMaps = matchedNames;

        // Show preview
        canvas.width = WIDTH;
        ctx.putImageData(imgData, 0, 0);
        ctx.strokeStyle="#FF0000";

        // Draw rectangles for preview
        let tmpCanvas = document.createElement('canvas');
        tmpCanvas.width = RECT_SIZE*2; tmpCanvas.height = RECT_SIZE*2;
        let tmpCtx = tmpCanvas.getContext('2d', {alpha: false});
        this.previewImages = [];
        for (let i = 0; i < this.$store.state.maps.length; i++) {
          const point = {
            x: this.$store.state.maps[i].atlas_x + X_OFFSET,
            y: this.$store.state.maps[i].atlas_y + Y_OFFSET
          };

          ctx.strokeStyle = matchedNames.has(this.$store.state.maps[i]) ? "#00FF00" : "#FF0000";
          ctx.strokeRect(point.x - RECT_SIZE/2, point.y - RECT_SIZE/2, RECT_SIZE, RECT_SIZE);

          let tmpImg = ctx.getImageData(point.x - RECT_SIZE, point.y - RECT_SIZE, RECT_SIZE*2, RECT_SIZE*2);
          tmpCanvas.width = RECT_SIZE*2; tmpCanvas.height = RECT_SIZE*2;
          tmpCtx.putImageData(tmpImg, 0, 0);
          if(this.previewImages[this.$store.state.maps[i].tier] === undefined) this.previewImages[this.$store.state.maps[i].tier] = [];
          this.previewImages[this.$store.state.maps[i].tier].push({
            name: this.$store.state.maps[i].name,
            dataURL: tmpCanvas.toDataURL("image/png")
          });
        }
        this.atlasImage = canvas.toDataURL("image/png");
      },
      sortTable(a, b, key) {
        if (key === 'completed') {
          if (this.completedMaps.has(a) && this.completedMaps.has(b)) return 0;
          if (this.completedMaps.has(a)) return -1;
          return 1;
        } else if (key === 'unique') {
          if (a.unique && b.unique) return 0;
          if (a.unique) return -1;
          return 1;
        } else return null;
      }
    }
  }
</script>
<style scoped>
  .table-checkbox {
    min-height: 1.1rem;
  }
</style>