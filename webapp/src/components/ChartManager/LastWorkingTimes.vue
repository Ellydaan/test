<template>
  <div class="flex flex-col gap-2 p-2">
    <h1 class="font-bold text-2xl">Mes derniers temps de travaille</h1>
    <v-data-table hide-default-footer theme="dark" :items="data"> </v-data-table>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import dateToElixirNaiveDate from '@/services/date-service'
import { api } from '@/services/axios-config'

const isLoading = ref(true)
const data = ref([])

const fetchLastWorkingTimes = async () => {
  try {
    const startDate = new Date(new Date().setDate(new Date().getDate() - 5))
    const response = await api.get(
      `/working_times/1?start=${dateToElixirNaiveDate(startDate, false)}`
    )
    data.value = response.data.data
    data.value.forEach((wt) => {
      wt.start = new Date(wt.start).toLocaleString()
      wt.end = new Date(wt.end).toLocaleString()
    })
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
}

onMounted(() => {
  setTimeout(() => {
    isLoading.value = false
  }, 1000)
  fetchLastWorkingTimes()
})
</script>

<style scoped></style>
