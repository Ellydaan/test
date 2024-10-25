<template>
  <aside class="w-64 bg-gray-800 p-4">
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-sulu-400">Gotham City</h1>
    </div>
    <nav>
      <ul class="space-y-2">
        <li>
          <a
            href="#"
            class="block py-2 px-4 rounded-full"
            :class="activeLink === 'Profile' ? 'bg-gray-700' : 'hover:bg-gray-700'"
            @click="setActiveLink('Profile')"
          >
            Profile
          </a>
        </li>
        <li>
          <a
            href="#"
            class="block py-2 px-4 rounded-full"
            :class="activeLink === 'Dashboard' ? 'bg-gray-700' : 'hover:bg-gray-700'"
            @click="setActiveLink('Dashboard')"
          >
            Dashboard
          </a>
        </li>
        <li>
          <a
            href="#"
            class="block py-2 px-4 rounded-full"
            :class="activeLink === 'Notifications' ? 'bg-gray-700' : 'hover:bg-gray-700'"
            @click="setActiveLink('Notifications')"
          >
            Notifications
          </a>
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script setup>
import { ref } from 'vue'

const activeLink = ref('Dashboard') // Default active link

function setActiveLink(link) {
  activeLink.value = link
}
</script>
