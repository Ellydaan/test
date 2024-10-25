<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <div class="box">
    <div class="box1">
      <form class="forms" @submit.prevent="handleSubmit">
        <input class="input" v-model="user.username" placeholder="Name" required />
        <input class="input" v-model="user.email" placeholder="Email" required />
        <button type="submit">Create User</button>
      </form>
      <div v-if="userData">
        <h2>Current User</h2>
        <p>Name: {{ userData.username }}</p>
        <p>Email: {{ userData.email }}</p>
      </div>
    </div>

    <p v-if="loading">Loading...</p>
    <p v-else-if="error">{{ error }}</p>

    <div class="box2" v-else>
      <table class="table-auto border-collapse border border-gray-400 w-full">
        <thead>
          <tr>
            <th class="border border-gray-400 px-4 py-2">Name</th>
            <th class="border border-gray-400 px-4 py-2">Email</th>
            <th class="border border-gray-400 px-4 py-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in info?.data" :key="user.id">
            <td class="border border-gray-400 px-4 py-2">
              <div v-if="user.id === editableUserId">
                <input class="input" v-model="user.username" placeholder="Username" />
              </div>
              <div v-else>
                {{ user.username }}
              </div>
            </td>
            <td class="border border-gray-400 px-4 py-2">
              <div v-if="user.id === editableUserId">
                <input class="input" v-model="user.email" placeholder="Email" />
              </div>
              <div v-else>
                {{ user.email }}
              </div>
            </td>
            <td class="border border-gray-400 px-4 py-2">
              <div v-if="user.id === editableUserId">
                <button class="btn" @click="saveUser(user)">Save</button>
              </div>

              <div class="actions" v-else>
                <!-- Bouton avec icône Delete -->
                <button class="btn" @click="deleteUser(user.id)">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M19 7l-1 12H6L5 7m5-4h4l1 1h-6l1-1z"
                    />
                  </svg>
                </button>
                <!-- Bouton avec icône Update -->
                <button class="btn" @click="editUser(user.id)">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M15.232 5.232l3.536 3.536-9.192 9.192H6v-3.536l9.192-9.192z"
                    />
                  </svg>
                </button>
                <!-- Lien avec icône Info -->
                <router-link class="btn" :to="`/about/${user.id}`">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M13 16h-1v-4h-1m0-4h.01M12 8v.01M19 11c0 4.418-3.582 8-8 8S3 15.418 3 11 6.582 3 11 3s8 3.582 8 8z"
                    />
                  </svg>
                </router-link>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      user: {
        username: '',
        email: ''
      },
      userData: null,
      info: null,
      loading: true,
      error: null,
      editableUserId: null
    }
  },

  mounted() {
    this.fetchUsers()
  },

  methods: {
    async fetchUsers() {
      try {
        const response = await axios.get('http://localhost:4000/api/users')
        this.info = response.data
      } catch (error) {
        console.error(error)
        this.error = 'An error occurred while fetching data'
      } finally {
        this.loading = false
      }
    },

    async deleteUser(id) {
      try {
        await axios.delete(`http://localhost:4000/api/users/${id}`)

        this.fetchUsers()
      } catch (error) {
        console.error('Error:', error)
      }
    },

    editUser(id) {
      this.editableUserId = id
    },

    async saveUser(user) {
      try {
        await axios.put(`http://localhost:4000/api/users/${user.id}`, {
          user: { username: user.username, email: user.email }
        })
        alert('User updated successfully')
        this.fetchUsers()
        this.editableUserId = null
      } catch (error) {
        console.error('Error:', error)
      }
    },

    async createUser() {
      try {
        const response = await axios.post('http://localhost:4000/api/users', {
          user: this.user
        })
        console.log(response.data)
        alert('User created successfully')
        this.fetchUsers()
        this.resetForm()
      } catch (error) {
        console.error('Error:', error)
      }
    },

    handleSubmit() {
      this.createUser()
    },

    resetForm() {
      this.user.username = ''
      this.user.email = ''
    }
  }
}
</script>

<style scoped>
.box {
  display: flex;
  flex-direction: column;
  gap: 40px;
}

input {
  padding: 5px;
  border: 2px solid #ddd;

  background-color: #f9f9f9;
  color: #333;
  font-size: 16px;
  transition:
    border-color 0.3s ease,
    box-shadow 0.3s ease;
}
input:focus {
  outline: 2px solid #9de338;
  box-shadow: none;
}

.forms {
  display: flex;
  flex-direction: row;
  gap: 20px;
}

.box1 {
  display: flex;
  flex-direction: column;
  gap: 40px;
}

.table-auto {
  width: 100%;
  border-collapse: collapse;
}

.actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
