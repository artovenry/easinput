<script lang="coffee">
  # import Easinput from "Easinput_tokened.vue"
  import Easinput from "Easinput_suggested.vue"
  export default components: {Easinput}
</script>
<template lang="pug">
  #root
    .container
      h1 easinput
      Easinput
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
