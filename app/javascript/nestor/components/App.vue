<template lang="pug">
v-app
  app-header
  v-content
    router-view
  v-footer(white)
    span.black--text &nbsp; Nestor the Chronicler 2018
</template>

<script>
  import AppHeader from "./AppHeader";
  export default {
    components: {
      AppHeader
    }
  };
</script>
<style lang="scss">
    $mdi-font-path: "~mdi/fonts/";
</style>
