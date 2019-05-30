<script lang="coffee">
  import Easinput from "Easinput.vue"
  # export default components: {Easinput}, data: ->value: "成城石井のチーズケーキと、しろまつがモナカ"
  export default components: {Easinput}, data: ->value: "チーズケーキ"
</script>
<template lang="pug">
  #root
    .container
      h1 easinput
      h2(style="width:100%;overflow:scroll;word-break: break-all;") {{value}}
      p: input(type="text" v-model="value")
      Easinput(v-model="value")
</template>
<style lang="scss">
  h1{margin: 0;padding:0;}
  .container{
    width: 100vw;height: 100vh;padding: 2rem;display: grid;
    grid-template-rows: 6rem min-content;
    justify-items: center;
    >h1{justify-self: center;align-self: center;}
  }
</style>
