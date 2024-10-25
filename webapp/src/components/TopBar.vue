<template>
  <!-- Header -->
  <header class="bg-gray-800 p-4 flex justify-between items-center">
    <h2 class="text-xl font-semibold">{{ props.role }} Dashboard</h2>
    <div class="flex items-center space-x-4">
      <button class="bg-sulu-500 text-white px-4 py-2 rounded">Upgrade Now</button>
      <div class="flex items-center space-x-2">
        <div class="w-9 h-9 rounded-full bg-gray-700"></div>
        <!-- Removed 'src' and 'alt', because this is a div, not an image -->
        <span>{{ `${props.firstname} ${props.lastname}` }}</span>
      </div>
    </div>
  </header>
</template>

<script setup>
import { defineProps } from 'vue'

const props = defineProps({
  role: String,
  firstname: String,
  lastname: String
})
</script>
