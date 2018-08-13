<template>
  <div>
    <b-form-file class="mb-3" v-model="atlasFile" accept="image/*" placeholder="Choose a file..."></b-form-file>

    <div v-if="atlasImage">
      <img :src="atlasImage" style="width:100%">
      <img v-for="elem in previewImages" :src="elem">
    </div>

    <div>
      <b-dropdown text="Dropdown Button" class="m-md-2">
        <b-dropdown-item v-for="elem in leagues">{{ elem.name }}</b-dropdown-item>
      </b-dropdown>
    </div>

    <!-- Completed maps-->
    {{completedMaps ? completedMaps.length : 0}}
    {{completedMaps ? completedMaps[15] : ''}}
    <ul>
      <li v-for="elem in completedMaps">
        {{elem.name}}
      </li>
    </ul>
  </div>
</template>

<script>
  import tinycolor from 'tinycolor2';
  import api from '../../api.js';

  export default {
    name: "AtlasParser",
    data() {
      return {
        maps: undefined,
        leagues: undefined,
        atlasFile: undefined,

        completedMaps: undefined,
        atlasImage: undefined,
        previewImages: []
      }
    },
    async created() {
      let mapPromise = api.maps().get();
      let leaguePromise = api.leagues().get();

      this.maps = (await mapPromise).data.maps;
      this.leagues = (await leaguePromise).data.leagues;
    },
    watch: {
      atlasFile() {
        this.parseScreenshot();
      }
    },
    methods: {
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
          let matchedNames = [];

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
              matchedNames.push(this.maps[i]);
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
          let tmpCtx = tmpCanvas.getContext('2d');
          for (let i = 0; i < this.maps.length; i++) {
            const point = {
              x: this.maps[i].atlas_x + X_OFFSET,
              y: this.maps[i].atlas_y + Y_OFFSET
            };

            // O(n^2), TODO replace w/ set
            ctx.strokeStyle = matchedNames.includes(this.maps[i]) ? "#00FF00" : "#FF0000";

            ctx.strokeRect(point.x - RECT_SIZE/2, point.y - RECT_SIZE/2, RECT_SIZE, RECT_SIZE);

            let tmpImg = ctx.getImageData(Math.max(0,Math.round((width - WIDTH) / 2)) + point.x - RECT_SIZE, point.y - RECT_SIZE, RECT_SIZE*2, RECT_SIZE*2);
            tmpCanvas.width = RECT_SIZE*2; tmpCanvas.height = RECT_SIZE*2;
            tmpCtx.putImageData(tmpImg, 0, 0);
            this.previewImages.push(tmpCanvas.toDataURL("image/png"));
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