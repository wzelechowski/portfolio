<template>
  <div class="container">
    <h2 class="text-center">{{ $t('volunteer-title') }}</h2>
    <table class="table table-striped">
      <thead>
      <tr>
        <th>ID</th>
        <th>{{ $t('profile-name') }}</th>
        <th>{{ $t('profile-surname') }}</th>
        <th>{{ $t('application-status') }}</th>
        <th>{{ $t('application-action') }}</th>
      </tr>
      </thead>
      <tbody v-for="(volunteers) in volunteers" :key="volunteers.id">
      <tr>
        <td>{{ volunteers.id }}</td>
        <td>{{ volunteers.name }}</td>
        <td>{{ volunteers.surname }}</td>
        <td>{{ volunteers.activity ? $t('volunteer-busy') : $t('volunteer-free') }}</td>
        <td>
          <button
              class="btn btn-primary btn-sm text-center w-40"
              @click="goToVolunteerDetails(volunteers.id)"
          >
            <font-awesome-icon icon="info-circle" /> {{  $t('profile-info') }}
          </button>
          <button
              class="btn btn-danger btn-sm text-center w-40"
              @click="deleteVolunteer(volunteers.id, volunteers.name, volunteers.surname)"
          >
            <font-awesome-icon icon="user-minus" /> {{  $t('volunteer-delete') }}
          </button>
        </td>
      </tr>
      </tbody>
    </table>
    <div v-if="successMessage" class="alert alert-success">
      {{ successMessage }}
    </div>
    <div v-if="loading" class="text-center">
      <i class="fas fa-spinner fa-spin"></i> {{ $t('organization-loading') }}
    </div>
    <div v-if="error" class="alert alert-danger">
      {{ $t('organization-error1') }} {{ error }}
    </div>
  </div>
</template>

<script>
import axios from "axios";
import authHeader from "@/services/auth-header.js";

export default {
  name: "VolunteerList",
  data() {
    return {
      volunteers: [], // Lista aplikacji
      expandedInfo: {}, // Zmienna przechowująca informacje o widoczności szczegółów dla aplikacji
      loading: true, // Flaga ładowania
      error: null,
      successMessage: null,// Obsługa błędów
    };
  },
  mounted() {
    this.fetchVolunteers();
  },
  methods: {
    async fetchVolunteers() {
      const API_URL = "http://localhost:8080/api/user"; // URL backendu
      try {
        const response = await axios.get(`${API_URL}/allVolunteersByOrganizationId`, {
          headers: authHeader(),
        });
        this.volunteers = response.data;
        this.loading = false;
      } catch (err) {
        this.error = err.message || $t('organization-error4');
        this.loading = false;
      }
    },
    async deleteVolunteer(userId, name, surname) {
      const API_URL = "http://localhost:8080/api/user"; // Prawidłowy URL backendu
      try {
        const requestData = {
          id: userId,
        };
        const response = await axios.post(
            `${API_URL}/deleteVolunteer`,
            requestData,
            {
              'Content-Type': 'application/json',
              headers: authHeader(),
            }
        );
        this.successMessage = `${this.$t('volunteer-messege-detete')}: ${name} ${surname}`;
        setTimeout(() => (this.successMessage = null), 3000);
        this.fetchVolunteers()
      } catch (err) {
        console.error("Błąd pobierania statusu approval:", err.message);
      }
    },
    goToVolunteerDetails(volunteerId) {
      this.$router.push(`/volunteer/info/${volunteerId}`);
    },
  }
};
</script>

<style scoped>
.container {
  margin-top: 20px;
}

.table {
  margin-top: 20px;
}

.text-center {
  text-align: center;
}

.badge {
  color: black;
  font-size: 1em;
  padding: 0.3em 0.8em;
  margin-left: 30px;
  border-radius: 0.2em;
}

.btn {
  margin-left: 5px;
  margin-right: 5px;
}

.badge-success {
  background-color: #28a745;
}

.badge-danger {
  background-color: #dc3545;
}
</style>
