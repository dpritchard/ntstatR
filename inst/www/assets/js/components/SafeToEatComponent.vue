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
    props: ['value'],
    data() {
        return {
            answer: this.value,
            basename: "safeToEat",
            question: "Is the kai safe to eat?",
            options: {
                0: {val: 0, level: "danger", msg: "It is certain that dangerous contamination is currently taking place."},
                1: {val: 1, level: "danger", msg: "It is certain that dangerous contamination takes place regularly."},
                2: {val: 2, level: "danger", msg: "Lower-level risk of contamination is currently taking place."},
                3: {val: 3, level: "warning", msg: "This site is at continual risk of contamination, with peaks after rain. The risk is hard to detect at this site."},
                4: {val: 4, level: "success", msg: "No obvious sign of contamination"}
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
            return [this.basename, val].join('-')
        },
    },

    computed: {
        name() {
            return this.basename
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
