<template lang="pug">
  v-app
    app-header
    v-content
      router-view
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
