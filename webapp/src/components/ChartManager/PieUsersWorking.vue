<template>
  <div class="chart-container">
    <PieChart :chartData="chartData" :options="chartOptions" />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { PieChart } from 'vue-chart-3'
import { api } from '@/services/axios-config.ts'
import { Chart, registerables } from 'chart.js'
Chart.register(...registerables)

const data = ref({
  working_users: 0,
  not_working_users: 0
})

const fetchChartData = async () => {
  try {
    const response = await api.get('/chartManager/is_working/users')
    data.value.not_working_users = response.data.data.not_working_users
    data.value.working_users = response.data.data.working_users
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
}
fetchChartData()
const chartData = computed(() => ({
  labels: ['Au travail', 'Pas au travail'],
  datasets: [
    {
      data: [data.value.working_users, data.value.not_working_users],
      backgroundColor: ['rgb(192, 241, 117)', 'rgb(255, 99, 132)']
    }
  ]
}))

const chartOptions = ref({
  responsive: true,
  aspectRatio: 1,
  backgroundColor: 'rgb(18, 24, 38)'
})
</script>

<style>
.chart-container {
  height: 200px;
  width: 200px;
}
</style>
