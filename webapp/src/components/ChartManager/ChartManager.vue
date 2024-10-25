<template>
  <div class="grid grid-cols-2 gap-6 mb-6">
    <div class="rounded bg-gray-800 p-4">
      <BarHoursWorked />
    </div>
    <div class="rounded bg-gray-800 p-4">
      <ClockingModule />
    </div>
  </div>
  <div class="grid-cols-1">
    <div class="rounded bg-gray-800 p-4">
      <LastWorkingTimes />
    </div>
  </div>
</template>

<script setup lang="ts">
import BarHoursWorked from '@/components/ChartManager/BarHoursWorked.vue'
import ClockingModule from '@/components/ChartManager/ClockingModule.vue'
import LastWorkingTimes from '@/components/ChartManager/LastWorkingTimes.vue'
</script>

<style scoped></style>
