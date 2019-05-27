<script lang="coffee">
KEYCODES= COMMA: 188
Vue.config.keyCodes.comma= KEYCODES.COMMA
focus= ->
  return if @readOnly or not $newTag= @$el.querySelector(".new-tag")
  $newTag.focus()
add= (e)->

data= ->
  active: no
  readOnly: no
  newTag: ""
export default data: data, methods: {focus}
</script>
<template lang="pug">
  #easinput(@click="focus"  :class="{'read-only': readOnly, active: active}")
    span(v-for="(item, index) in tags"  :key="index" class="tag")
      span {{item}}
      a.remove(v-if="!readOnly"  @click.prevent.stop="remove(index)")
    input.new-tag(
      type="text" placeholder="new tag"
      v-show="!readOnly"
      v-model="newTag"
      @keydown.delete.stop="removeLastTag"
      @keydown.enter="add"
      @keydown.comma="add"
      @keydown.tab="add"
      @blur="blurInput"
      @focus="focusInput"
    )
</template>
<style lang="scss">
  #easinput{
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
