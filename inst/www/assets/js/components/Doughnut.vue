<template>
    <canvas class="mx-auto" data-chart="dougnut"></canvas>
</template>

<script>
export default {
    props: ['score', 'scoreMax', 'height'],

    computed: {
        finalColour() {
            if(this.score == 0){
                return ['#C9C9C9', '#D72E3D']
            } else if(this.score <= this.scoreMax*0.5) {
                return ['#D72E3D', '#C9C9C9']
            } else if (this.score <= this.scoreMax*0.75) {
                return ['#FFB90B', '#C9C9C9']
            } else {
                return ['#249D3D', '#C9C9C9']
            }
        }
    },

    mounted() {
        console.log(this.score);
        let config = {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [this.score, this.scoreMax-this.score],
                    backgroundColor : this.finalColour,
                    borderWidth: [0, 0],
                }],
            },
            options: {
                responsive: true,
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
        // console.log(config);
        // console.log(this.$el);
        new chart(this.$el, config)
    }
};
</script>
