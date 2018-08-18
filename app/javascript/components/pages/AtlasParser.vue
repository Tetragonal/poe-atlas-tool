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

      <transition name="fade">
      <div v-if="previewImages.length > 0">
        <hr>

        <!-- Overview -->
        <div class="card-body">
          <h3 class="card-text">
            Completion Overview
          </h3>

          <b-card-group deck>
            <b-card header="Atlas Progress">
              <p class="card-text">
                {{ completedMaps.size }}/{{ maps.length }} maps completed ({{(100.0*completedMaps.size/maps.length).toFixed(0)}}%)
              </p>
              <b-progress class="mb-3" style="height:25px" :max="maps.length" show-value>
                <b-progress-bar :value="completedMaps.size" variant="success"></b-progress-bar>
                <b-progress-bar :value="maps.length - completedMaps.size" variant="secondary"></b-progress-bar>
              </b-progress>
            </b-card>
            <b-card header="Map Preview">
              <b-input-group class="mb-3"
                             prepend="Tier"
                             :append="'(' + Array.from(completedMaps).filter(map => map.tier === selectedPreviewTier).length + '/' + previewImages[selectedPreviewTier].length + ' completed)'">
                <b-form-input type="number" :min="minTier" :max="maxTier" v-model.number="selectedPreviewTier"></b-form-input>
              </b-input-group>

              <span v-for="(tier, index) in previewImages" v-if="index === selectedPreviewTier">
              <b-img v-for="map in tier" :src="map.dataURL" width="40px"
                     v-b-tooltip :title="map.name"></b-img>
            </span>
            </b-card>
          </b-card-group>
        </div>

        <hr>

        <!-- Details -->
        <div class="card-body">

        <p class="card-text">
          Some quick example text to build on the card title and make up the bulk of the card's content.
        </p>
        <b-button href="#" variant="primary">Go somewhere</b-button>

        </div>
      </div>
      </transition>
    </b-card>

    <div>
      <b-dropdown :text="selectedLeague ? selectedLeague.name : 'Select league'" class="m-md-2">
        <b-dropdown-item v-for="elem in leagues" @click="selectedLeague = elem">{{ elem.name }}</b-dropdown-item>
      </b-dropdown>
    </div>

    <div v-if="completedMaps">
      <!-- Completed maps-->
      Completed Maps: {{ completedMaps ? completedMaps.size : 0 }}
      <ul>
        <li v-for="elem in maps" v-if="!elem.unique && completedMaps.has(elem)">
          {{ elem.name }}
        </li>
      </ul>

      <!-- Uncompleted maps-->
      Uncompleted Maps: {{ completedMaps ? maps.length - completedMaps.size : maps.length }}
      <ul>
        <li v-for="elem in maps" v-if="!elem.unique && !completedMaps.has(elem)">
          {{ elem.name }}
        </li>
      </ul>

      Unique Maps:
      <ul>
        <li v-for="elem in maps" v-if="elem.unique">
          {{ elem.name }}
          <b-badge pill variant="success">{{ completedMaps.has(elem) ? 'Complete' : '' }}</b-badge>
        </li>
      </ul>
    </div>

  </div>
</template>

<script>
  import tinycolor from 'tinycolor2';
  import api from '../../api.js';

  export default {
    name: "AtlasParser",
    data() {
      return {
        // Data from API
        maps: undefined,
        leagues: undefined,
        atlasFile: undefined,

        // For upload
        selectedLeague: undefined,

        // Computed
        completedMaps: undefined,
        atlasImage: undefined,

        // Preview
        previewImages: [],
        selectedPreviewTier: 1

      }
    },
    async created() {
      let mapPromise = api.maps.get();
      let leaguePromise = api.leagues.get();

      this.maps = (await mapPromise).data.maps;
      this.leagues = (await leaguePromise).data.leagues;
    },
    watch: {
      atlasFile() {
        this.parseScreenshot();
      }
    },
    computed: {
      minTier() {
        if(this.maps === undefined || this.maps.length === 0) return undefined;
        let minTier = this.maps[0].tier;
        for(let map in this.maps) {
          if(map.tier < minTier ) minTier = map.tier;
        }
        return minTier;
      },
      maxTier() {
        if(this.maps === undefined || this.maps.length === 0) return undefined;
        let maxTier = this.maps[0].tier;
        for(let map of this.maps) {
          console.log(this.maps);
          if(map.tier > maxTier ) maxTier = map.tier;
        }
        console.log(maxTier);
        return maxTier;
      }
    },
    methods: {
      updateUser() {
        let mapIds = [];
        for(let map of this.completedMaps){
          mapIds.push(map.id);
        }
        api.progressions.post(this.$store.state.username, this.leagueId, mapIds);
      },
      parseScreenshot() {
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
        //Pixels matched threshold for map to be considered completed: 10%.
        const THRESHOLD = .10;
        //move Shaper's Realm to 491.8 to 500
        const X_OFFSET = 8;
        const Y_OFFSET = 56;


        const getColorIndicesForCoord = (x, y, width) => {
          const red = y * (width * 4) + x * 4;
          return [red, red + 1, red + 2, red + 3];
        };

        let img = new Image;
        img.onload = () => {
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

          for (let i = 0; i < this.maps.length; i++) {

            const point = {
              x: this.maps[i].atlas_x + X_OFFSET,
              y: this.maps[i].atlas_y + Y_OFFSET
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
              matchedNames.add(this.maps[i]);
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
          for (let i = 0; i < this.maps.length; i++) {
            const point = {
              x: this.maps[i].atlas_x + X_OFFSET,
              y: this.maps[i].atlas_y + Y_OFFSET
            };

            ctx.strokeStyle = matchedNames.has(this.maps[i]) ? "#00FF00" : "#FF0000";
            ctx.strokeRect(point.x - RECT_SIZE/2, point.y - RECT_SIZE/2, RECT_SIZE, RECT_SIZE);

            let tmpImg = ctx.getImageData(Math.max(0,Math.round((width - WIDTH) / 2)) + point.x - RECT_SIZE, point.y - RECT_SIZE, RECT_SIZE*2, RECT_SIZE*2);
            tmpCanvas.width = RECT_SIZE*2; tmpCanvas.height = RECT_SIZE*2;
            tmpCtx.putImageData(tmpImg, 0, 0);
            if(this.previewImages[this.maps[i].tier] === undefined) this.previewImages[this.maps[i].tier] = [];
            this.previewImages[this.maps[i].tier].push({
              name: this.maps[i].name,
              dataURL: tmpCanvas.toDataURL("image/png")
            });
          }
          this.atlasImage = canvas.toDataURL("image/png");
        };

        // Read file
        let reader = new FileReader();
        reader.onloadend = () => {
          img.src = reader.result;
        };
        reader.readAsDataURL(this.atlasFile);
      }
    }
  }
</script>