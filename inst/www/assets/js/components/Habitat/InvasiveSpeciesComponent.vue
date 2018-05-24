<template>
    <div>
    <p class="text-muted font-italic mb-0 mt-2">{{ question }}</p>
    <div class="form-check form-check-inline" v-for="(opt, key) in sortedOptions">
        <input class="form-check-input" type="radio"
            v-bind:name="name"
            v-bind:id="id(key)"
            v-bind:value="opt.val"
            v-model="answer">
        <label class="form-check-label" v-bind:for="id(key)">{{opt.label}}</label>
    </div>
    <div v-bind:class="msgClass">{{msg}}</div>
    </div>
</template>

<script>
export default {
    props: ['value', 'indx'],
    data() {
        return {
            answer: this.value,
            basename: "invasive-species",
            question: "Are new plants or animals (invasive species) taking over the site?",
            options: {
                NS: {val: -1, label: "-", level: "secondary", msg: "Not Sure."},
                0: {val: 0, label: "0", level: "danger", msg: "Blanketed. It is/they are everywhere."},
                1: {val: 1, label: "1", level: "danger", msg: "Lots of large patches."},
                2: {val: 2, label: "2", level: "danger", msg: "Some large or small patches."},
                3: {val: 3, label: "3", level: "warning", msg: "A few small patches."},
                4: {val: 4, label: "4", level: "success", msg: "None."}
            }
        }
    },

    watch: {
        answer(val) {
            this.$emit('input', val);
        }
    },

    methods: {
        id(val) {
            return ['habitat', this.basename, val].join('-')
        },
    },

    computed: {
        name() {
            return 'habitat-' + this.basename
        },
        msg() {
            return _.find(this.options, ['val', this.answer]).msg
        },
        msgClass() {
            return 'text-' + _.find(this.options, ['val', this.answer]).level
        },
        sortedOptions() {
            return _.sortBy(this.options, 'val')
        }
    }

};
</script>
