<!-- App.vue -->
<template>
  <DashboardLayout />
</template>

<script>
import DashboardLayout from './components/DashboardLayout.vue'

export default {
  name: 'App',
  components: {
    DashboardLayout
  }
}
</script>

<style>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

body {
  margin: 0;
  padding: 0;
  font-family: 'Arial', sans-serif;
}

#app {
  height: 100vh;
}
</style>
