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
            basename: "tasteCondition",
            question: "Is the kai tasty and in good condition?",
            options: {
                0: {val: 0, level: "danger", msg: "The stocks are severely unhealthy or stressed, and are most likely in poor condition. They may or may not be safe to eat."},
                1: {val: 1, level: "danger", msg: "The stocks are severely stressed or starving, and are unlikely to be reproducing or growing well. They probably won't taste good."},
                2: {val: 2, level: "danger", msg: "The stocks are lightly stressed but the population as a whole may be producing and growing well. The majority taste good."},
                3: {val: 3, level: "warning", msg: "People might gather this species occasionally but are likely to prefer another species or site."},
                4: {val: 4, level: "success", msg: "Everyone can consistently gather safe and tasty species for kai here."}
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
