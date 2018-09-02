<template lang="pug">
  v-toolbar-items(:class="{'sm-hide': smHide }")
    v-btn(flat
     v-for="item in items" :key="item.index") {{ item.title }}
</template>
<script>
  export default {
    props: ['items', 'smHide'],
  }
</script>
<style lang="scss">
    .sm-hide {
        display: none !important;
    }
</style>
