<template>
  <div class="box">
    <p v-if="loading">Loading...</p>
    <p v-else-if="error">{{ error }}</p>
    <ul v-else>
      <div class="form" v-for="user in info.data" :key="user.id">
        <input class="input" type="text" v-model="user.username" placeholder="Username" />
        <input type="email" v-model="user.email" placeholder="Email" />

        <button @click="deleteUser(user.id)">suprimer</button>
        <button @click="updateUser(user)">Modifier</button>
        <router-link :to="`/about/${user.id}`">Go to About</router-link>
      </div>
    </ul>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      info: null,
      loading: true,
      error: null
    }
  },

  mounted() {
    axios
      .get('http://localhost:4000/api/users')
      .then((response) => {
        this.info = response.data
      })
      .catch((error) => {
        console.error(error)
        this.error = 'An error occurred while fetching data'
      })
      .finally(() => {
        this.loading = false
      })
  },

  methods: {
    async deleteUser(id) {
      try {
        await axios.delete(`http://localhost:4000/api/users/${id}`)
        alert('User deleted successfully')
      } catch (error) {
        console.error('Error:', error)
        alert('Error deleting user')
      }
    },

    async updateUser(user) {
      try {
        const response = await axios.put(`http://localhost:4000/api/users/${user.id}`, {
          user: { username: user.username, email: user.email }
        })
        alert('User updated successfully')
        return response
      } catch (error) {
        console.error('Error:', error)
        alert('Error updating user')
      }
    }
  }
}
</script>

<style scoped>
.input {
  width: 300px;
  height: 30px;
  border-radius: 2px solid black;
}

.form {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 10px;
}
</style>
