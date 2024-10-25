<template>
  <div class="flex flex-col h-[100%]">
    <div class="card-header">
      <h1 class="font-bold text-2xl">Clocking</h1>
    </div>
    <div class="flex flex-col justify-center items-center h-[100%] gap-10">
      <v-progress-circular
        v-if="isLoading"
        color="rgb(192, 241, 117)"
        indeterminate
        :size="60"
      ></v-progress-circular>
      <p v-else-if="workingTime" class="font-bold text-5xl">{{ workingTime }}</p>
      <p v-else class="font-bold text-2xl">Pas de pointage en cours</p>
      <button
        class="btn"
        :class="{ clockOut: isClocking === true, clockIn: isClocking === false }"
        @click="handleClocking"
      >
        {{ isClocking ? 'Clock Out' : 'Clock In' }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { api } from '@/services/axios-config'
import dateToElixirNaiveDate from '@/services/date-service'

const workingTime = ref(null)
const lastClocking = ref({ id: null, status: false, time: null, user_id: null })
const isClocking = computed(() => lastClocking.value.status)
const isLoading = ref(true)
const newClock = ref(null)
let timer = null

const fetchLastClocking = async () => {
  try {
    const response = await api.get('/clocks/1/last')
    lastClocking.value = response.data.data
    updateTimer()
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
}

const updateTimer = () => {
  clearInterval(timer)
  if (isClocking.value) {
    timer = setInterval(() => {
      const now = new Date()
      const diff = now - new Date(lastClocking.value.time)
      workingTime.value = new Date(diff).toISOString().substr(11, 8)
    }, 1000)
  } else {
    workingTime.value = null
  }
}

const handleClocking = async () => {
  const newStatus = !isClocking.value
  try {
    await api
      .post('/clocks/1', {
        clocks: {
          status: newStatus,
          time: dateToElixirNaiveDate(new Date(), true)
        }
      })
      .then((r) => (newClock.value = r.data.data))
    if (newClock.value.status === false) {
      await api.post('/working_times/1', {
        working_times: {
          start: lastClocking.value.time,
          end: newClock.value.time
        }
      })
    }
    await fetchLastClocking()
  } catch (error) {
    console.error('Erreur lors du pointage:', error)
  }
}

onMounted(() => {
  setTimeout(() => (isLoading.value = false), 2000)
  fetchLastClocking()
})
onUnmounted(() => clearInterval(timer))
</script>

<style scoped>
.btn {
  height: 45px;
  width: 120px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.clockIn {
  background-color: rgb(192, 241, 117, 0.8);
}

.clockOut {
  background-color: rgb(255, 99, 132);
}
</style>
