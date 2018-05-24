<template>
    <canvas class="mx-auto" data-chart="dougnut" v-bind:height="height"></canvas>
</template>

<script>
export default {
    props: ['score', 'scoreMax', 'height'],

    computed: {
        finalColour() {
            if(this.score < this.scoreMax*0.5) {
                return '#FF0000'
            } else if (this.score < this.scoreMax*0.75) {
                return '#FFC300'
            } else {
                return '#008000'
            }
        }
    },

    mounted() {
        console.log(this.doughnutData);
        let config = {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [this.score, this.scoreMax-this.score],
                    backgroundColor : [this.finalColour, '#C9C9C9'],
                    borderWidth: [0, 0],
                }],
            },
            options: {
                responsive: false,
                cutoutPercentage: 70,
                tooltips: {
                    enabled: false,
                },
                hover: {
                    mode: null
                },
                legend: {
                    display: false,
                },
                title: {
                    display: false,
                },
                animation: {
                    animateScale: true,
                    animateRotate: true
                }
            }
        };
        console.log(config);
        console.log(this.$el);
        new chart(this.$el, config)
    }
};
</script>
