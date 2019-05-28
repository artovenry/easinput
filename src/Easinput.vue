<script lang="coffee">
import Vue from "vue"
Vue.config.keyCodes.comma= 188

export default
  props: readOnly: no, value: default: ->[]
  data: -> active: no, newTag: "", tags: [@value...]
  watch:
    tags: (val)->@$emit "update:tags", val;@$emit "input", val
    value: ->@tags= [@value...]
  methods:
    focus: ->if not @readOnly then @$el.querySelector(".new-tag")?.focus()
    add: ->@tags.push @newTag;@newTag= ""
    pop: ->@tags.pop() if @newTag is ""
    remove: (index)->@tags.splice(index, 1)
</script>
<template lang="pug">
  .easinput(@click="focus"  :class="{'read-only': readOnly, active: active}")
    span.tag(v-for="(item, index) in tags"  :key="index")
      span {{item}}
      a.remove(v-if="!readOnly"  @click.prevent.stop="remove(index)")
    input.new-tag(
      type="text" placeholder="new tag"
      v-if="!readOnly"
      v-model="newTag"
      @keydown.delete.stop="pop"
      @keydown.enter.prevent="add"
      @keydown.comma.prevent="add"
      @keydown.tab.prevent="add"
      @blur="active= false"
      @focus="active= true"
    )
</template>
<style lang="scss">
  .easinput{
    width: 100%;height: 3rem;
    border: 1px solid #CCC;border-radius: 8px;
    appearance: textfield;cursor: text;
    display: flex;flex-flow: row wrap;align-items: center;
    .new-tag{
      background: transparent;
      border: 0;
      outline: none;
      flex: auto;
    }

  }
</style>
