<template>
<div>
    <div class="row">
        <div class="col-lg">
            <WaterQuality v-model="localWaterQuality" />
        </div>
        <div class="col-lg">
            <AnoxicSediment v-model="localAnoxicSediment" />
        </div>
        <div class="col-lg">
            <Sediment v-model="localSediment" />
        </div>
    </div>
    <div class="row">
        <div class="col-lg">
            <InvasiveSpecies v-model="localInvasiveSpecies" />
        </div>
        <div class="col-lg">
            <SeaweedSeagrass v-model="localSeaweedSeagrass" />
        </div>
        <div class="col-lg">
            <AlgalBloom v-model="localSeaweedSeagrass" />
        </div>
    </div>
</div>
</template>

<script>
export default {
    props: ["waterQuality", "anoxicSediment", "sediment", "invasiveSpecies", "seaweedSeagrass", "ulvaBloom"],
    data() {
        return {
            localWaterQuality: this.waterQuality,
            localAnoxicSediment: this.anoxicSediment,
            localSediment: this.sediment,
            localInvasiveSpecies: this.invasiveSpecies,
            localSeaweedSeagrass: this.seaweedSeagrass,
            localUlvaBloom: this.ulvaBloom
        }
    },

    components: {
        // TODO HERE
        'WaterQuality': require('./Habitat/WaterQualityComponent.vue'),
        'AnoxicSediment': require('./Habitat/AnoxicSedimentComponent.vue'),
        'Sediment': require('./Habitat/SedimentComponent.vue'),
        'InvasiveSpecies': require('./Habitat/InvasiveSpeciesComponent.vue'),
        'SeaweedSeagrass': require('./Habitat/SeaweedSeagrassComponent.vue'),
        'AlgalBloom': require('./Habitat/AlgalBloomComponent.vue')
    },

    watch: {
        localWaterQuality(val) {
            this.$emit('update:waterQuality', val);
        },
        localAnoxicSediment(val) {
            this.$emit('update:anoxicSediment', val);
        },
        localSediment(val) {
            this.$emit('update:sediment', val);
        },
        localInvasiveSpecies(val) {
            this.$emit('update:invasiveSpecies', val);
        },
        localSeaweedSeagrass(val) {
            this.$emit('update:seaweedSeagrass', val);
        },
        localUlvaBloom(val) {
            this.$emit('update:ulvaBloom', val);
        },
    },

    methods: {

    },

    computed: {

    }

};
</script>
