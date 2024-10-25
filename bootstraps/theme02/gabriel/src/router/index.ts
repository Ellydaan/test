import { createRouter, createWebHistory } from 'vue-router'
import CurrentWeather from '@/components/CurrentWeather.vue'


const routes = [
  {
    path: '/',
    redirect: '/currentWeather/paris'
  },
  {
    path: '/currentWeather/:city',
    component: CurrentWeather
  },
  {
    path: '/forecastChart/:city',
    component: Forecast
  }
]


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: routes,
})

export default router
