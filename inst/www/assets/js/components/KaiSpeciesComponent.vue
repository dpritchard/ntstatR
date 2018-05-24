<template>
<div class="container p-0 mb-4">
    <div class="row">
      <div class="col-lg-4 d-flex align-items-center">
          <button class="btn btn-danger btn-sm mr-2" v-bind:class="{ 'disabled': !canRemoveSpecies }" @click.prevent="delSpp(indx)">Delete</button>
          <input v-bind:id="speciesNameId" v-bind:name="speciesNameName" type="text" class="form-control form-control-sm" v-model="localName" placeholder="Species Name (Optional)">
      </div>
      <div class="col-lg">
          <p class="text-muted font-italic mb-0 mt-2">Is the species sedentary?</p>
          <div class="form-check form-check-inline">
            <input v-bind:id="sedId('true')" v-bind:name="sedName" class="form-check-input" type="radio" value="true" v-model="localSedentary">
            <label v-bind:for="sedId('true')" class="form-check-label">Yes</label>
          </div>
          <div class="form-check form-check-inline">
            <input v-bind:id="sedId('false')" v-bind:name="sedName" class="form-check-input" type="radio" value="false" v-model="localSedentary">
            <label v-bind:for="sedId('false')" class="form-check-label">No</label>
          </div>
      </div>
    </div>
    <div class="row">
      <div class="col-lg">
        <kai-species-replace v-model="localReplace" v-bind:indx="indx"></kai-species-replace>
      </div>
      <div class="col-lg">
        <kai-species-get-a-feed v-model="localGetAFeed" v-bind:sedentary.sync="sedentary" v-bind:indx="indx"></kai-species-get-a-feed>
      </div>
      <div class="col-lg">
        <kai-species-taste-condition v-model="localTasteCondition" v-bind:indx="indx"></kai-species-taste-condition>
      </div>
    </div>
</div>
</template>

<script>
export default {
    props: ['indx', 'name', 'sedentary', 'replace', 'getAFeed', 'tasteCondition', 'canRemoveSpecies'],
    data() {
        return {
            localName: this.name,
            localSedentary: this.sedentary,
            localReplace: this.replace,
            localGetAFeed: this.getAFeed,
            localTasteCondition: this.tasteCondition
        }
    },

    components: {
        'kai-species-replace': require('./KaiSpecies/ReplaceComponent.vue'),
        'kai-species-taste-condition': require('./KaiSpecies/TasteConditionComponent.vue'),
        'kai-species-get-a-feed': require('./KaiSpecies/GetAFeedComponent.vue')
    },

    watch: {
        localName(val) {
            this.$emit('update:name', val);
        },
        localSedentary(val) {
            this.$emit('update:sedentary', val);
        },
        localReplace(val) {
            this.$emit('update:replace', val);
        },
        localGetAFeed(val) {
            this.$emit('update:getAFeed', val);
        },
        localTasteCondition(val) {
            this.$emit('update:tasteCondition', val);
        },
    },

    methods: {
        delSpp(indx) {
            this.$emit('delete-species', indx)
        },
        sedId(val) {
            return ['kai-species', this.indx, 'sedentary', val].join('-')
        }
    },

    computed: {
        speciesNameName() {
            return 'kai-species[' + this.indx + '][name]'
        },
        speciesNameId() {
            return ['kai-species', this.indx, 'name'].join('-')
        },
        sedName() {
            return 'kai-species[' + this.indx + '][sedentary]'
        }
    }



};
</script>
