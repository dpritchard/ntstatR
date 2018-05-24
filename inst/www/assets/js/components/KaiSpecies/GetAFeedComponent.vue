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
    props: ['value', 'indx', 'sedentary'],
    data() {
        return {
            answer: this.value,
            basename: "getAfeed",
            question: "Can you get a feed easily enough?",
            options: {
                0: {val: 0, level: "danger", msg: "Something (probably habitat degradation, sedimentation or overfishing) has driven this population extinct."},
                1: {val: 1, level: "danger", msg: "The species is present but stocks are severely depleted; thus the species is functionally extinct. People will not try to gather here, even if they have a boat or can dive."},
                2: {val: 2, level: "danger", msg: "People will gather here occasionally if they have a boat, special gear or they can dive, but they are unlikely to ever fish here from shore."},
                3: {val: 3, level: "warning", msg: "People may gather here occasionally by wading from shore. Divers and those with boats or special gear will fish here regularly, and will probably get an adequate feed."},
                4: {val: 4, level: "success", msg: "Everyone can quickly and regularly gather enough of this species for kai here."}
            }
        }
    },

    watch: {
        answer(val) {
            this.$emit('input', val);
        },
        sedentary(val) {
            if(val=="true") {
                this.options[3].msg = "People may gather here occasionally by wading from shore. Divers and those with boats or special gear will fish here regularly, and will probably get an adequate feed."
            } else {
                this.options[3].msg = "People will fish here regularly if they have a boat and/or gear, or can dive. They will fish from shore occasionally."
            }
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
