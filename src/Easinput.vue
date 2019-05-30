<script lang="coffee">
import {chain, value, map, flatten, pluck, groupBy ,detect, contains} from "underscore"
DATA= require "./items.yml"
categories= pluck(DATA, "category")
ITEMS= flatten(pluck(DATA, "items"))
DEFAULT_ITEMS= ITEMS[0..8]
categorize= (arg)->
  chain(arg)
  .map (item, index)->value: item, index: index
  .groupBy (item)->
    detect DATA, (DATUM)->contains(DATUM.items, item.value)
    .category
  .map (item, key)->category: key, items: item
  .value()

bh= new Bloodhound
  datumTokenizer: Bloodhound.tokenizers.whitespace
  queryTokenizer: Bloodhound.tokenizers.whitespace
  local: ITEMS
  identify: JSON.stringify    # THIS IS DEV VERSION
export default
  props: value: default : ""
  data: ->query: "", suggested: [], active: no, cursor: -1, token: @value
  watch:
    query: (query)-> @resetCursor();bh.search query, (rs)=>@suggested= rs
    cursor: (val)->
      lastIndex= @suggested.length - 1
      if val < -1 then @cursor= lastIndex
      if lastIndex < val then @cursor= -1
    token: (val)-> @$emit "update:token", val; @$emit "input" , val;
  methods:
    categorize: categorize
    toggle: (state)->@$el.querySelector('.easinput--token--query')[if state then 'focus' else 'blur']()

    resetCursor: ->@cursor= -1
    resetQuery: ->@query= ""
    resetToken: ->@token= ""
    resetSuggestion: ->@suggested= []
    onCursorUpDown: (e)->
      [UP, DOWN]= [38, 40]
      @suggested= DEFAULT_ITEMS if @query is ""
      if e.keyCode is UP then @cursor--
      if e.keyCode is DOWN then @cursor++
    onDelete: ->return if @query isnt ""; @resetToken();
    onEnter: -> return if @cursor is -1; @token= @suggested[@cursor]; @resetCursor(); @resetQuery();@resetSuggestion();@toggle(off)
    onClickItem: (index)->@token= @suggested[index]; @resetCursor(); @resetQuery();@resetSuggestion();@toggle(off)
</script>
<template lang="pug">
  .easinput
    .easinput--token-wrapper(:class="{active}" @click="toggle(true)")
      span.easinput--token(v-if="token") {{token}}
      input.easinput--token--query(type="text"  :placeholder="token ? '' : '材料'"
        v-model="query"
        @focus="active= true" @blur="active= false"
        @keydown.delete.stop="onDelete"
        @keydown.down.prevent="onCursorUpDown"
        @keydown.up.prevent="onCursorUpDown"
        @keydown.enter.prevent="onEnter"
      )
    .easinput--suggested(v-if="active && suggested.length > 0")
      template(v-for="(cItem, cIndex) in categorize(suggested)")
        .easinput--suggested--category-name {{cItem.category}}
        .easinput--suggested--item(
          v-for="(item, iIndex) in cItem.items"
          :key="cItem.category+'_'+iIndex"
          :class="{active: cursor === item.index}"
          @click="onClickItem(item.index)"
        ) {{item.value}}
</template>
<style lang="scss">
  // GLOBAL
  input[type='text']{margin:0;padding:0;}


  @mixin layout{
    &-wrapper{
      width: 100%;padding: .5rem .25rem .5rem .25rem;
      display: flex; flex-wrap: wrap;
      align-items: center;
      font-size: .8rem;
    }
    word-break: break-all;
    &, &--query{padding: .3em!important;}
    &, &--query{margin:.5em!important;}
    &--query{flex-grow: 1;width: 50%;}
  }

  .easinput{
    width: 100%;
    position: relative;
    &--token{
      @include layout;
      &-wrapper{
        border: 1px solid #CCC;border-radius: 8px;
        // appearance: textfield;cursor: text;
      }
      &, &--query{
        background: rgb(143, 236, 194);color: rgb(50, 50, 50);
        border-radius: 4px;
      }
      &--query{
        border: 0;outline: none;
      }
    }



    &--suggested{
      position: absolute;
      width: 100%; top:calc(3rem + 10px);
      border: 1px solid #CCC;border-radius: 8px;
      appearance: textfield;cursor: text;
      box-shadow: 0 5px 10px rgba(0,0,0,.2);
      display: flex;flex-flow: column;
      padding: 8px;
      &--category-name{
        font-weight: bold;
        border-bottom: 2px solid #666;
      }
      &--item{
        &.active{color:red;}
      }
    }
  }
</style>
