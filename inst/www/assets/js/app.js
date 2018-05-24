
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./init_vendors'); // Might consider splitting this out into vendor.js and loading on the page seperatley

window.Vue = require('vue');
Vue.component('safe-to-eat', require('./components/SafeToEatComponent.vue'));
Vue.component('kai-species', require('./components/KaiSpeciesComponent.vue'));
Vue.component('habitat', require('./components/HabitatComponent.vue'));
Vue.component('doughnut', require('./components/Doughnut.vue'));


function kaiSpeciesDefault() {
    return {
        id: _.uniqueId('kai-species-'),
        name: '',
        sedentary: "true",
        replace: 4,
        getAFeed: 4,
        tasteCondition: 4
    }
};

const app = new Vue({
    el: '#app',

    data: {
        id: 0,
        safeToEat: 4,
        kaiSpecies: [kaiSpeciesDefault()],
        habitat: {
            waterQuality: 4,
            anoxicSediment: 4,
            sediment: 4,
            invasiveSpecies: 4,
            seaweedSeagrass: 4,
            ulvaBloom: 4,
        },
        calcScore: null,
        calcError: null
    },

    computed: {
        canAddSpecies() {
            return this.kaiSpecies.length < 5
        },
        canRemoveSpecies() {
            return this.kaiSpecies.length > 1
        },
        habitatCalcData() {
            return _.toArray(this.habitat)
        },
        sppCalcData() {
            let out = {
                names: [],
                scores: []
            }
            _.forEach(this.kaiSpecies, function(object) {
                 out.scores.push([object.replace, object.getAFeed, object.tasteCondition]);
                 out.names.push(object.name);
            });
            return out
        },
        calcData() {
            return {
                'safe': this.safeToEat,
                'spp': this.kaiSpecies,
                'habitat': this.habitatCalcData
            }
        },
        finalScorePercent() {
            return 444
            // return calcScore.final_ratio*100
            // _.round(calcScore.final_ratio[0]*100)
        }
    },

    methods: {
        onSubmit() {
            this.calcScore = null;
            this.calcError = null;
            // Optionally the request above could also be done as
            axios.post('https://cloud.opencpu.org/ocpu/apps/dpritchard/ntstatR/R/statm/json', this.calcData)
              .then(response => {
                  this.calcScore = response.data;
                  console.log(response.data);
              })
              .catch(error => {
                  if (error.response) {
                    // The request was made and the server responded with a status code
                    // that falls out of the range of 2xx
                    this.calcError = error.response.data;
                    console.log(error.response.data);
                    console.log(error.response.status);
                    console.log(error.response.headers);
                  } else if (error.request) {
                    // The request was made but no response was received
                    // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
                    // http.ClientRequest in node.js
                    this.calcError = 'No repsonse received from server. Please try again later.';
                    console.log(error.request);
                  } else {
                    // Something happened in setting up the request that triggered an Error
                    this.calcError = 'There was an error sending the request for calculation. Please try again later.';
                    console.log('Error', error.message);
                  }
                  console.log(error.config);
              });
        },

        addSpp() {
            if (this.canAddSpecies) {
                this.kaiSpecies.push(kaiSpeciesDefault());
            }
        },

        delSpp(indx) {
            if (this.canRemoveSpecies) {
                this.kaiSpecies.splice(indx,1)
            }
        },
    },
});
