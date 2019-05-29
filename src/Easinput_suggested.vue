<script lang="coffee">
import {chain, value, map, flatten, pluck, groupBy ,detect, contains} from "underscore"
ITEMS= require "./items.yml"
categories= pluck(ITEMS, "category")
items= flatten(pluck(ITEMS, "items"))
bh= new Bloodhound
  datumTokenizer: Bloodhound.tokenizers.whitespace
  queryTokenizer: Bloodhound.tokenizers.whitespace
  local: items
  identify: JSON.stringify    # THIS IS DEV VERSION
export default
  data: ->query: "", suggested: [], active: no, cursor: -1, value: null
  computed:
    suggestedRow: ->
      chain(@suggested)
      .map (item, index)->value: item, index: index
      .groupBy (item)->
        detect ITEMS, (ITEM)->contains(ITEM.items, item.value)
        .category
      .map (item, key)->category: key, items: item
      .value()
    $queryEl: ->@$el.querySelector('.easinput-query')
  watch:
    query: (query)-> @resetCursor();bh.search query, (rs)=>@suggested= rs
    cursor: (val)->
      lastIndex= @suggested.length - 1
      if val < -1 then @cursor= lastIndex
      if lastIndex < val then @cursor= -1
    value: (val)-> @$emit (if val? then "update:value" else "reset:value"), val
  methods:
    resetCursor: ->@cursor= -1
    resetQuery: ->@query= ""
    resetValue: ->@value=null
    focus: ->@$queryEl.focus()
    blur: ->@$queryEl.blur()
    deassign: ->if @query is ""
      @resetValue()
    assign: -> if @cursor isnt -1
      @value= @suggested[@cursor]
      @resetCursor(); @resetQuery();@blur()
</script>
<template lang="pug">
  .easinput-container
    .easinput(:class="{active}" @click="focus")
      span.easinput-value(v-if="value") {{value}}
      input.easinput-query(type="text" placeholder="材料"
        v-model="query"
        @focus="active= true" @blur="active= false"
        @keydown.delete.stop="deassign"
        @keydown.down.prevent="cursor++"
        @keydown.up.prevent="cursor--"
        @keydown.enter.prevent="assign"
      )
    .suggested-wrapper(v-if="active && suggested.length > 0")
      template(v-for="(cItem, cIndex) in suggestedRow")
        .category-name {{cItem.category}}
        .suggested-item(
          v-for="(item, iIndex) in cItem.items"
          :key="cItem.category+'_'+iIndex"
          :class="{active: cursor === item.index}"
        ) {{item.value}}
</template>
<style lang="scss">
  .easinput-container{
    width: 100%;
    position: relative;
  }
  .easinput{
    height: 3rem;
    appearance: textfield;cursor: text;
    display: flex;flex-flow: row wrap;align-items: center;
    border: 1px solid #CCC;border-radius: 8px;
    &-query{
      border: 0;
      background: transparent;
      outline: none;
      flex: auto;
    }
  }
  .suggested{
    &-wrapper{
      position: absolute;
      width: 100%; top:calc(3rem + 10px);
      border: 1px solid #CCC;border-radius: 8px;
      appearance: textfield;cursor: text;
      box-shadow: 0 5px 10px rgba(0,0,0,.2);
      display: flex;flex-flow: column;
    }
    &-item{
      &.active{color:red;}
    }
  }
</style>
