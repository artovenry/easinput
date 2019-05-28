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
  data: ->query: "", suggested: [], active: no, cursor: -1
  watch:
    query: (query)->
      bh.search query, (rs)=>
        @suggested= chain(rs)
          .groupBy (item)->
            detect ITEMS, (ITEM)->contains(ITEM.items, item)
            .category
          .map (item, key)->category: key, items: item
          .value()


</script>
<template lang="pug">
  .easinput
    input(type="text" placeholder="材料"
      v-model="query"
      @focus="active= true" @blur="active= false"
    )
    .suggested-wrapper(v-if="active")
      template(v-for="(cItem, cIndex) in suggested")
        .category-name {{cItem.category}}
        .suggested-item(v-for="(item, iIndex) in cItem.items" :key="cItem.category+'_'+iIndex") {{item}}
</template>
<style lang="scss">
  .easinput{
    width: 100%;height: 3rem;
    position: relative;
    input{
      width: 100%;height: 3rem;
      border: 1px solid #CCC;border-radius: 8px;
      background: transparent;
      outline: none;
    }
    .suggested-wrapper{
      position: absolute;
      width: 100%; top:calc(3rem + 10px);
      border: 1px solid #CCC;border-radius: 8px;
      appearance: textfield;cursor: text;
      box-shadow: 0 5px 10px rgba(0,0,0,.2);
      display: flex;flex-flow: column;
    }
  }
</style>
