<template>
  <div>
    <h1>Gestion du Temps de Travail</h1>

    <div>
      <h2>Créer un Temps de Travail</h2>
      <form @submit.prevent="createWorkingTime">
        <input
          v-model="newWorkingTime.start"
          type="datetime-local"
          required
          placeholder="Date de début"
        />
        <input
          v-model="newWorkingTime.end"
          type="datetime-local"
          required
          placeholder="Date de fin"
        />
        <button type="submit">Créer</button>
      </form>
    </div>

    <div>
      <h2>Temps de Travail Existants</h2>
      <ul>
        <li v-for="workingTime in workingTimes" :key="workingTime.id">
          <span>{{ workingTime.start }} - {{ workingTime.end }}</span>

          <button @click="updateWorkingTime(workingTime.id)">Modifier</button>
          <button @click="deleteWorkingTime(workingTime.id)">Supprimer</button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      userId: this.$route.params.id,
      workingTimes: [],
      newWorkingTime: {
        start: '',
        end: ''
      }
    }
  },
  methods: {
    async getWorkingTimes() {
      try {
        const response = await axios.get(`http://localhost:4000/api/working_times/${this.userId}`)
        console.log("Réponse de l'API:", response.data)

        this.workingTimes = response.data.data
      } catch (error) {
        console.error('Error fetching working times:', error)
      }
    },

    async createWorkingTime() {
      try {
        const response = await axios.post(
          `http://localhost:4000/api/working_times/${this.userId}`,
          {
            working_times: {
              start: this.newWorkingTime.start,
              end: this.newWorkingTime.end
            }
          }
        )
        console.log('Réponse du serveur:', response.data)
        await this.getWorkingTimes()

        this.newWorkingTime.start = ''
        this.newWorkingTime.end = ''
      } catch (error) {
        console.error('Erreur lors de la création du temps de travail:', error)
      }
    },

    async updateWorkingTime(workingTimeId) {
      try {
        const response = await axios.put(
          `http://localhost:4000/api/working_times/${this.userId}/${workingTimeId}`,
          {
            working_times: {
              start: this.newWorkingTime.start,
              end: this.newWorkingTime.end
            }
          }
        )
        console.log('Réponse du serveur:', response.data)

        await this.getWorkingTimes()

        this.newWorkingTime.start = ''
        this.newWorkingTime.end = ''
      } catch (error) {
        console.error('Erreur lors de la mise à jour du temps de travail:', error)
      }
    },

    async deleteWorkingTime(workingTimeId) {
      try {
        const response = await axios.delete(
          `http://localhost:4000/api/working_times/${workingTimeId}`
        )
        console.log('Réponse du serveur:', response.data)
        await this.getWorkingTimes()
      } catch (error) {
        console.error('Erreur lors de la suppression du temps de travail:', error)
      }
    }
  },

  mounted() {
    console.log('Composant monte')
    this.getWorkingTimes()
  }
}
</script>
