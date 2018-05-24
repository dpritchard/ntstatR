<template>
    <div>
    <p class="text-muted font-italic mb-0 mt-2">{{ question }}</p>
    <div class="form-check form-check-inline" v-for="opt in options">
        <input class="form-check-input" type="radio"
            v-bind:name="name"
            v-bind:id="id(opt.val)"
            v-bind:value="opt.val"
            v-model="answer">
        <label class="form-check-label" v-bind:for="id(opt.val)">{{opt.val}}</label>
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
            basename: "replace",
            question: "Is the kai replacing itself?",
            options: {
                0: {val: 0, level: "danger", msg: "The population is extinct or virtually extinct at this site."},
                1: {val: 1, level: "danger", msg: "The population is not replacing itself from within the area."},
                2: {val: 2, level: "danger", msg: "Some breeding but little recruitment is happening. The population is unlikely to be replacing itself from within the area."},
                3: {val: 3, level: "warning", msg: "Breeding or recruitment may be reduced. The population may not be fully replacing itself from within the area."},
                4: {val: 4, level: "success", msg: "Strong breeding and recruitment is happening from within the area."}
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
            return ['kai-species', this.indx, this.basename, val].join('-')
        },
    },

    computed: {
        name() {
            return 'kai-species[' + this.indx + '][' + this.basename + ']'
        },
        msg() {
            return this.options[this.answer.toString()].msg
        },
        msgClass() {
            return 'text-' + this.options[this.answer.toString()].level
        }
    }

};
</script>
