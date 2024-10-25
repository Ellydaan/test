<template>
  <div class="chart-bar-container">
    <h1 class="font-bold text-2xl">Heures des 7 derniers jours</h1>
    <LineChart :chartData="chartData" :options="chartOptions" :height="350" />
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { LineChart } from 'vue-chart-3'
import { api } from '@/services/axios-config.ts'
import { Chart, registerables } from 'chart.js'
Chart.register(...registerables)

const data = ref([])

const fetchChartData = async () => {
  try {
    const response = await api.get(`/chartManager/1`)
    data.value = response.data.data
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
}

if (data.value.length === 0) {
  fetchChartData()
}
const chartData = computed(() => ({
  labels: data.value.map((data) => data[0]),
  datasets: [
    {
      label: 'Heures travaillées',
      data: data.value.map((data) => data[1]),
      fill: true,
      borderColor: 'rgb(192, 241, 117)',
      tension: 0.1
    }
  ]
}))

const chartOptions = ref({
  responsive: true
})
</script>

<style>
.chart-bar-container {
  width: 100%;
}
</style>
